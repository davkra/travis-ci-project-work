# Fiktives Projekt

Author: David Krall

---

Dieses Projekt gilt als Beispiel oder "Fiktives" Projekt, um die Automatische Buildumgebung mit Jenkins zu testen. Die derzeit verwendet Programmiersprachen sind C/C++ und Java, wobei sich der Aufbau des Projekts noch verändern beziehungsweise das Projekt vergrößern könnte.

Im Grunde handelt es sich um ein `HelloWord` Programm des `Java Native Interface (JNI)`.

Eine Shared Library wird in C/C++ mit Hilfe von g++ kompiliert und im Anschluss wird zusätzlich eine Shared Library für Java erstellt. Die Shared Library wird in `MyNativeClass` in Java geladen und starten die Funktionen, welche in C/C++ geschrieben wurden.

## Table of Content

- [Fiktives Projekt](#fiktives-projekt)
  - [Table of Content](#table-of-content)
  - [TL;DR](#tldr)
  - [Projekt Struktur](#projekt-struktur)
  - [C/C++ Shared Library](#cc-shared-library)
  - [javatester](#javatester)
    - [Build Skripte](#build-skripte)
  - [Verschiedenes](#verschiedenes)
  - [Referenzen](#referenzen)

---

## TL;DR

1. Starten der Demo mit Hilfe des `run_demo.sh` Skripts

    ```bash
    ./run_demo.sh
    ```

2. Alle Libraries und das Maven Projekt werden erstellt und die Java `main()` wird ausgeführt.

## Projekt Struktur

In diesem Projekt gibt es einen Teil in welchen die C/C++ Funktionen deklariert und implementiert werden und einen Teil für die Implementation in Java. (`javatester`)

*Alle notwendigen Schritte zum Kompilieren können aus dem `run_demo.sh` Bash-Skript entnommen werden.*

## C/C++ Shared Library

Die Shared Library (`libTest.so`) kann mit Hilfe von `CMake` und `make` erstellt werden, während man sich im root Verzeichnis des Projekts befindet.

```bash
cmake . && make
```

Der Source Code befindet sich unter `src/`, die Header Dateien in `inc/` und die erstellte Shared Library wird in das Verzeichnis `lib/` abgelegt.

## javatester

In diesem Projekt Abschnitt wird die zuvor erstellte `libTest.so` mit Hilfe des Java Native Interfaces zu einer Shared Library, welche mit Java kompatibel ist, kompiliert. Im Anschluss wird diese in einem Java Program, welches zusätzlich in einer `jar`Datei verpackt ist, geladen.

Dieser Abschnitt ist ein Maven Projekt namens `javatester` und in diesem Verzeichnis befinden sich zwei Bash-Skripts `01_build.sh` und `02_run.sh`. Mit Hilfe des ersten Skripts wird das Maven Projekt kompiliert und die `jar` Datei erstellt. Dazu muss man sich natürlich im Verzeichnis `javatester` befinden.

```bash
mvn clean package
```

`01_build.sh` erstellt außerdem die notwendigen Java Native Header Dateien und erstellt, wie bereits erwähnt, die mit Java kompatible Shared Library `libmyNativeLibrary.so`, welche in der Java Main Klasse `MyNativeClass.java` verwendet wird.
`02_run.sh` konfiguriert die richtigen Pfade für `libTest.so` und `libmyNativeLibrary.so`, welche für das Starten der Main Klasse benötigt werden und starten die Main Klasse `MyNativeClass`.

```bash
./01_build.sh
./02_run.sh
```

Das Maven Projekt beinhaltet den Code für die Java Main Klasse `MyNativeClass.java` unter `src/main/java/at/libtester/`. Der C/C++ Code für das Native Interface befindet sich unter `src/main/java`, gemeinsam mit der Shared Library `libmyNativeLibrary.so` unter `src/main/java/lib`.

**Die Dateistruktur im Gesamtprojekt muss korrekt sein, da ansonsten Fehler beim Starten der Main Klasse auftreten können!**

```bash
java.lang.NoClassDefFoundError: at/libtester/MyNativeClass (wrong name: MyNativeClass)
```

**`java` muss innerhalb des `at` Verzeichnisses gestartet werden. Immer zuerst zum Parent-Verzeichnis von `at` wechseln!**

Nach dem Starten der Main Klasse, ist der Output der aufgerufenen C/C++ Funktionen im Terminal sichtbar.

### Build Skripte

Hier werden die verwendeten Skripte für den `javatester` kurz beschrieben.

`01_build.sh`

```bash
# Build header file
javac -h . at/libtester/MyNativeClass.java

# Build shared object file
mkdir -p ./lib/
g++ -I../../../../inc/ -I"/usr/lib/jvm/java-17-openjdk-amd64/include/" -I"/usr/lib/jvm/java-17-openjdk-amd64/include/linux/" -shared -fPIC -o ./lib/libmyNativeLibrary.so at_libtester_MyNativeClass.cpp ../../../../lib/libTest.so
```

`02_run.sh`

```bash
# Configure library paths
export LD_LIBRARY_PATH=../../../../javatester/src/main/java/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=../../../../lib:$LD_LIBRARY_PATH

# Run the Main class MyNativeClass
java -cp ../../../target/javatester-1.0-SNAPSHOT.jar at.libtester.MyNativeClass
```

## Verschiedenes

In Bash kann der Befehl `file` verwendet werden, um zu überprüfen, ob die Shared Library richtig kompiliert wurde:

```bash
file libmyNativeLibrary.so
```

In Visual Studio Code muss die `jni.h` Datei möglicherweise manuell zum C/C++ Dateipfad hinzugefügt werden.

```json
{
    "C_Cpp.default.includePath": [
    "/usr/lib/jvm/java-17-openjdk-amd64/include/*"
  ]
}
```

## Referenzen

- [https://github.com/spbwilson/jni-example](https://github.com/spbwilson/jni-example)
- [https://mustafa-aydogan.medium.com/how-to-call-c-functions-from-java-how-to-use-jni-java-native-interface-fd6aafcb9ee9](https://mustafa-aydogan.medium.com/how-to-call-c-functions-from-java-how-to-use-jni-java-native-interface-fd6aafcb9ee9)
- [https://medium.com/@Neelesh-Janga/run-native-code-in-a-java-environment-using-jni-0dac9c3e6c39](https://medium.com/@Neelesh-Janga/run-native-code-in-a-java-environment-using-jni-0dac9c3e6c39)
