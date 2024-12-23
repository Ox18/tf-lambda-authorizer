docker:zip
	docker run -it -v /home/wilmer/web/software-empresarial/authorizer:/tmp terraform bash

dockerwin:
	docker run -it -v /home/wilmer/web/software-empresarial/authorizer:/tmp terraform bash

zip:
	zip lambda.zip handler.js

apply:
	terraform apply

init:
	terraform init