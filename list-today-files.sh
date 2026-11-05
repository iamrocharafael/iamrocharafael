# Listar arquivos de hoje
alias lshoje='ls -al --time-style=+%D | grep `date +%D`'

# Lista grupos
alias grupos='cut -d: -f1 /etc/group'

# otimizar pdf
alias otimizarpdf='ps2pdf -dPDFSETTINGS=/ebook'

# Mostrar permissão
alias permissão='stat -c "(%F)- %n %a %A" "$@"'

# Mostrar as montagens por coluna
alias cmount="mount | column -t"

# Mostrar portas abertas/ativas tcp e udp
alias portas='netstat -tulanp'
