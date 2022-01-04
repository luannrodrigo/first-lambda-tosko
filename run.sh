# 1 - Criar arquivo com as politicas de segurança
# 2 - criar role de segurança na AWS

aws iam create-role \
    --role-name lambda-exemplo \
    --assume-role-policy-document file://policy.json \
    | tee logs/role.log

# 03 - criar aquivo com contúdo e comprimir para fazer o deploy
zip function.zip index.js

aws lambda create-function \
	--function-name hello-cli \
	--zip-file fileb://function.zip \
	--handler index.handler \
	--runtime nodejs14.x \
	--role arn:aws:iam::070486574427:role/lambda-exemplo \
	| tee logs/lambda-create.log


# 4 invoke lambda
aws lambda invoke \
	--function-name hello-cli \
	--log-type Tail \
	logs/lambda-exec.log


# 5 - atualizar função
zip function.zip index.js

# 6 - atualizar lambda
aws lambda update-function-code \
	--zip-file fileb://function.zip \
	--function-name hello-cli \
	--publish \
	| tee logs/lambda-update.log

# 07 invoke 

aws lambda invoke \
	--function-name hello-cli \
	--log-type Tail \
	logs/lambda-exec.log

# remove
aws lambda delete-function \     
	--function-name hello-cli  

aws iam delete-role \
    --role-name lambda-exemplo