# download SCALE-MAMBA
cd 
git clone https://github.com/KULeuven-COSIC/SCALE-MAMBA.git
cd SCALE-MAMBA
git checkout 862ecf547
cp /root/src/CONFIG.mine .
patch -p1 -i ~/src/sm.patch
cp /root/src/Input_Output* src/Input_Output/
make progs

# set up certificate authority
SUBJ="/CN=www.example.com"
cd Cert-Store

openssl genrsa -out RootCA.key 4096
openssl req -new -x509 -days 1826 -key RootCA.key \
           -subj $SUBJ -out RootCA.crt

# make 5 certificates. More can be added as necessary
mkdir csr
for ID in {0..9}
do
  SUBJ="/CN=player$ID@example.com"
  openssl genrsa -out Player$ID.key 2048
  openssl req -new -key Player$ID.key -subj $SUBJ -out csr/Player$ID.csr
  openssl x509 -req -days 1000 -set_serial 101$ID \
    -CA RootCA.crt -CAkey RootCA.key \
    -in csr/Player$ID.csr -out Player$ID.crt 
done

# copy example to correct locations
cd /root/SCALE-MAMBA
EX="noe"
mkdir Programs/$EX
cp /root/src/$EX.mpc Programs/$EX/
cp /root/src/*.sh .

# add simple syntax highlighting and vim bindings
cd
git clone https://github.com/marsella/vim.git
mv vim/.vim* .
mv src/mamba.vim .vim/syntax
echo "au BufNewFile,BufRead *.mpc set filetype=mamba" > .vim/ftdetect/mamba.vim


