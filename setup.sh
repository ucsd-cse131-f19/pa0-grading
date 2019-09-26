apt-get -y install valgrind nasm clang m4
apt-get update -y

# https://opam.ocaml.org/doc/Install.html
wget https://raw.github.com/ocaml/opam/master/shell/opam_installer.sh -O - | sh -s /usr/local/bin
opam init --root=/usr/local/opam --comp=4.05.0

cat >> ~/.bashrc <<EOF
eval `opam config env --root=/usr/local/opam/`
. /usr/local/opam/opam-init/init.sh
EOF
source ~/.bashrc

opam install --root=/usr/local/opam extlib ounit ocamlfind core


# This last line must stay to avoid ssh errors
ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts
