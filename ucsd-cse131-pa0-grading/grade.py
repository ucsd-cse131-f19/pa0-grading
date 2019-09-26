import os
import json
import subprocess
import shutil
import re

shutil.copy2("gradingTests.ml", "/autograder/submission/")
shutil.copy2("functions.mli", "/autograder/submission/")
if os.path.exists("/autograder/submission/compiler"):
    shutil.copy2("42.int", "/autograder/submission/compiler/")
os.chdir("/autograder/submission/")
with open("_tags", "w"):
    pass


subprocess.Popen(" ".join(["ocamlc", "functions.mli"]),
                 stdout=subprocess.PIPE,
                 stdin=subprocess.PIPE,
                 stderr=subprocess.PIPE,
                 shell=True).communicate("")
# Student's Tests
out_build, err_build = subprocess.Popen(" ".join(["make", "test"]),
                                        stdout=subprocess.PIPE,
                                        stdin=subprocess.PIPE,
                                        stderr=subprocess.PIPE,
                                        shell=True).communicate("")
out_run, err_run = subprocess.Popen(" ".join(["./test"]),
                                    stdout=subprocess.PIPE,
                                    stdin=subprocess.PIPE,
                                    stderr=subprocess.PIPE,
                                    shell=True).communicate("")

# OCaml Basics
out_basics_build, err_basics_build = subprocess.Popen(" ".join(
    ["ocamlbuild", "-pkg", "oUnit", "-no-hygiene", "gradingTests.native"]),
    stdout=subprocess.PIPE,
    stdin=subprocess.PIPE,
    stderr=subprocess.PIPE,
    shell=True).communicate("")

out_basics_run, err_basics_run = subprocess.Popen(" ".join(["./gradingTests.native",
                                                            "-output-file",
                                                            "results.log"]),
                                                  stdout=subprocess.PIPE,
                                                  stdin=subprocess.PIPE,
                                                  stderr=subprocess.PIPE,
                                                  shell=True).communicate("")

basics_cases = 0
basics_passed = 0
basics_failed = 0

if os.path.exists("results.log"):
    with open("results.log") as f:
        lines = f.readlines()
        basics_cases = int(re.search('Cases: (\d+).', lines[-7]).group(1))
        basics_failed = int(re.search('Failures: (\d+).', lines[-4]).group(1))
        basics_passed = basics_cases - basics_failed

# Compiler
compiler_score = 0
out_cmp, err_cmp = "", ""
out_asm, err_asm = "", ""
out_ln, err_ln = "", ""
out_run, err_run = "", ""
if os.path.exists("/autograder/submission/compiler"):
    os.chdir("/autograder/submission/compiler")
    out_cmp, err_cmp = subprocess.Popen(" ".join(["ocaml", "compile.ml", "42.int",
                                                  ">", "42.s"]),
                                        stdout=subprocess.PIPE,
                                        stdin=subprocess.PIPE,
                                        stderr=subprocess.PIPE,
                                        shell=True).communicate("")
    out_asm, err_asm = subprocess.Popen(" ".join(["nasm", "-f", "elf32", "-o",
                                                  "42.o", "42.s"]),
                                        stdout=subprocess.PIPE,
                                        stdin=subprocess.PIPE,
                                        stderr=subprocess.PIPE,
                                        shell=True).communicate("")
    out_ln, err_ln = subprocess.Popen(" ".join(["clang", "-m32", "-o", "42.run",
                                                "main.c", "42.o"]),
                                      stdout=subprocess.PIPE,
                                      stdin=subprocess.PIPE,
                                      stderr=subprocess.PIPE,
                                      shell=True).communicate("")
    out_run, err_run = subprocess.Popen(" ".join(["./42.run"]),
                                        stdout=subprocess.PIPE,
                                        stdin=subprocess.PIPE,
                                        stderr=subprocess.PIPE,
                                        shell=True).communicate("")
    compiler_score = 21 if out_run == "42\n" else 0

total_score = {
    'output': "",
    'tests': [
        {
            "name": "stdout",
            "output": out_build + "\n" + out_run
        },
        {
            "name": "stderr",
            "output": err_build + "\n" + err_run
        },
        {
            "name": "OCaml Basics: %d/%d tests passed" % (basics_passed, basics_cases),
            "output": out_basics_build + "\n" + out_basics_run,
            "score": basics_passed
        },
        {
            "name": "OCaml Basics: stderr",
            "output": err_basics_build + "\n" + err_basics_run
        },
        {
            "name": "Compiler: %d/%d" % (compiler_score, 21),
            "output": out_cmp + "\n" + out_asm + "\n" + out_ln + "\n" + out_run,
            "score": compiler_score
        },
        {
            "name": "Compiler: stderr",
            "output": err_cmp + "\n" + err_asm + "\n" + err_ln + "\n" + err_run
        }
    ]
}

if(os.path.isdir("/autograder/results")):
    resultsjson = open("/autograder/results/results.json","w")
    resultsjson.write(json.dumps(total_score))
    resultsjson.close()
else:
    print("local test")
    print json.dumps(total_score, indent=4, sort_keys=True)
