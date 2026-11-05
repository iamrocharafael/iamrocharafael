# SCRIPT DE VERIFICAÇÃO DE BACKUP

# --- CONFIGURAÇÕES ---
# Diretório onde os backups são salvos
DIRETORIO_BACKUP="/caminho/para/seu/diretorio/backups"

# Padrão ou nome do arquivo de backup (suporta wildcards como *)
# Exemplo 1: "backup_app_*.tar.gz"
# Exemplo 2: "backup_app_$(date +%Y%m%d).zip"
PADRAO_ARQUIVO="backup_app_*.tar.gz"

# Idade máxima do arquivo em minutos (ex: 1440 min = 24 horas)
TEMPO_MAXIMO_MINUTOS=1440

# Email/Webhook para alertas (opcional)
EMAIL_ALERTA="seu_email@empresa.com"

# ==============================================================================
# FUNÇÕES DE VERIFICAÇÃO
# ==============================================================================

log_msg() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

enviar_alerta() {
    local assunto="$1"
    local mensagem="$2"
    log_msg "ENVIANDO ALERTA: $assunto"
    
    # Exemplo enviando e-mail via comando mail/mailx (requer postfix/sendmail configurado)
    # echo "$mensagem" | mail -s "$assunto" "$EMAIL_ALERTA"
}

# 1. Verificar se o diretório existe
if [ ! -d "$DIRETORIO_BACKUP" ]; then
    log_msg "ERRO CRÍTICO: O diretório $DIRETORIO_BACKUP não existe."
    enviar_alerta "ERRO: Diretório de Backup Ausente" "O diretório $DIRETORIO_BACKUP não foi encontrado no servidor."
    exit 1
fi

# 2. Buscar o arquivo de backup mais recente dentro do padrão especificado
ARQUIVO_RECENTE=$(find "$DIRETORIO_BACKUP" -type f -name "$PADRAO_ARQUIVO" -printf '%T@ %p\n' 2>/dev/null | sort -n | tail -1 | cut -f2- -d" ")

# 3. Verificar se algum arquivo foi encontrado
if [ -z "$ARQUIVO_RECENTE" ]; then
    log_msg "ERRO: Nenhum arquivo de backup com o padrão '$PADRAO_ARQUIVO' foi encontrado em $DIRETORIO_BACKUP."
    enviar_alerta "ERRO: Backup não encontrado" "Nenhum arquivo de backup correspondente a $PADRAO_ARQUIVO foi localizado."
    exit 1
fi

log_msg "Arquivo mais recente encontrado: $ARQUIVO_RECENTE"

# 4. Verificar se o arquivo não está vazio (tamanho > 0 bytes)
if [ ! -s "$ARQUIVO_RECENTE" ]; then
    log_msg "ERRO CRÍTICO: O arquivo de backup $ARQUIVO_RECENTE está VAZIO (0 bytes)."
    enviar_alerta "ERRO: Arquivo de Backup Vazio" "O arquivo $ARQUIVO_RECENTE possui 0 bytes."
    exit 1
fi

# 5. Verificar a idade do arquivo (se foi atualizado no período esperado)
# find com -mmin verifica minutos desde a última modificação
NOVO_O_SUFICIENTE=$(find "$ARQUIVO_RECENTE" -mmin -$TEMPO_MAXIMO_MINUTOS 2>/dev/null)

if [ -z "$NOVO_O_SUFICIENTE" ]; then
    log_msg "ERRO: O backup $ARQUIVO_RECENTE é antigo (gerado há mais de $TEMPO_MAXIMO_MINUTOS minutos)."
    enviar_alerta "ERRO: Backup Desatualizado" "O último backup encontrado ($ARQUIVO_RECENTE) tem mais de $((TEMPO_MAXIMO_MINUTOS/60)) horas de criação."
    exit 1
fi

# ==============================================================================
# SUCESSO
# ==============================================================================
log_msg "SUCESSO: O backup recente existe, possui conteúdo e está dentro do prazo ($ARQUIVO_RECENTE)."
exit 0

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Lembrando que é necessário tornar o script executável, ajustar variáveis caso necessário e realizar configuração no Contab:

1 - chmod +x verifica_backup.sh

2 - DIRETORIO_BACKUP: Caminho completo de onde o backup é gerado.
PADRAO_ARQUIVO: Nome exato ou expressão com * do arquivo (ex: site_db_*.sql.gz).
TEMPO_MAXIMO_MINUTOS: Janela de tempo aceitável (1440 min = 24 horas; 720 min = 12 horas).

3 - crontab -e 

Snippet de código

0 7 * * * /caminho/para/verifica_backup.sh >> /var/log/verifica_backup.log 2>&1

