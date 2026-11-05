Eu uso muito alias e funções no bash/zsh que facilita o dia a dia.
Estou criando este tópico para quem quiser compartilhar as suas alias

# Colorir páginas de manuais
export LESS_TERMCAP_mb=$(printf '\e[01;31m') # Entrar no modo intermitente - vermelho
export LESS_TERMCAP_md=$(printf '\e[01;35m') # Entrar no modo de duplo brilho - negrito, magenta
export LESS_TERMCAP_me=$(printf '\e[0m') # Desativar todos os modos de aparência (mb, md, so, us)
export LESS_TERMCAP_se=$(printf '\e[0m') # Deixar o modo standout
export LESS_TERMCAP_so=$(printf '\e[01;33m') # Entrar no modo standout - amarelo
export LESS_TERMCAP_ue=$(printf '\e[0m') # Deixar o modo sublinhado
export LESS_TERMCAP_us=$(printf '\e[04;36m') # Entrar no modo sublinhado - ciano
