local messages = {
	"Encontrou algum bug ou quer ter contato com mais jogadores? Participe do nosso grupo no Whatsapp!",
	"Seja um apoiador e ajude o servidor a crescer: fa�a uma doa��o e ganhe acesso ao conte�do da nossa store!",
	"N�o conhece os comandos do servidor?\n Utilize o comando !commands e seja feliz. :)",
	"Dificuldades no level up ou n�o consegue dropar aquele item? Seja VIP e ganhe vantagens exclusivas! :)",
	"Donatou via PagSeguro/PayPal e n�o ca�ram suas moedas? Crie um ticket em nosso site. Doa��es via PicPay devem ser confirmadas no account management com as informa��es da compra.",
	"Aten��o: EVITEM usar senhas de outros servidores aqui no Skelot. Jogadores est�o sendo hackeados por este motivo e, se o n�mero de casos for muito alto, ser� imposs�vel ajudar a todos.",
	"Utilizem o 2FA (double authenticator) e tornem suas contas 100% seguras! O mesmo pode ser ativado no account management, em:\n skelot.com/?subtopic=accountmanagement&action=auth",
}

function onThink(interval)
	local msg = messages[math.random(#messages)]
	Game.broadcastMessage(msg, MESSAGE_EVENT_ADVANCE)
	return true
end