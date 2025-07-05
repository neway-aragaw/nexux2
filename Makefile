# --------- CONFIG ---------
AWS_REGION=us-east-1
AWS_ACCOUNT_ID=050752638165
IMAGE_NAME=python-api
IMAGE_TAG=latest
ECR_URL=$(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com/$(IMAGE_NAME)
APP_PATH=apps/python-api

# --------- TARGETS ---------

login:
	aws ecr get-login-password --region $(AWS_REGION) | docker login --username AWS --password-stdin $(AWS_ACCOUNT_ID).dkr.ecr.$(AWS_REGION).amazonaws.com

build:
	docker build -t $(IMAGE_NAME):$(IMAGE_TAG) $(APP_PATH)

tag:
	docker tag $(IMAGE_NAME):$(IMAGE_TAG) $(ECR_URL):$(IMAGE_TAG)

push: login build tag
	docker push $(ECR_URL):$(IMAGE_TAG)

update-deploy:
	sed -i "s|image: .*|image: $(ECR_URL):$(IMAGE_TAG)|g" $(APP_PATH)/deployment.yaml

# Run everything except git commit
all: push update-deploy
