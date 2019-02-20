preview:
	./create-preview-script.sh

clean:
	cp ./create-preview-script.sh /tmp/
	rm *.bak
	rm instancegroup/*.bak
	git reset --hard origin/master
	cp /tmp/create-preview-script.sh .

apply:
	./create-cluster.sh

build:
	./build-cluster.sh

delete:
	./delete-cluster.sh
