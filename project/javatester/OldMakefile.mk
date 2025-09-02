
all:	MyNativeClass.java
	javac -h . MyNativeClass.java
	mkdir -p ./lib/
	g++ -I../inc -I"/usr/lib/jvm/java-17-openjdk-amd64/include/" -I"/usr/lib/jvm/java-17-openjdk-amd64/include/linux/" -shared -fPIC -o ./lib/libmyNativeLibrary.so MyNativeClass.cpp ../src/hello.cpp ../src/add.cpp

run: all
	@env LD_LIBRARY_PATH=$LD_LIBRARY_PATH:./lib java MyNativeClass
