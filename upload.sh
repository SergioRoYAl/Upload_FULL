#!/bin/bash

#PREPARADO DE SPRINGBOOT

#COPIANDO LAS PROPIEDADES DEL SERVIDOR SPRINGBOOT CON LA CONFIGURACION MYSQL SEGURA DEL DROPLET
echo "COPIANDO PROPIEDADES \n\n\n\n\n"
sudo cp ~/lluiment/droplet ~/lluiment/back-LLU/src/main/resources/application.properties

#EJECUCION DEL CLEAN EN EL SPRING BOOT
echo "LIMPIANDO PROYECTO \n\n\n\n\n"
cd ~/lluiment/back-LLU
"/home/xthan/lluiment/back-LLU/mvnw" clean -f "/home/xthan/lluiment/back-LLU/pom.xml"

#PACKAGE EN .JAR SPRING BOOT
echo "CREANDO .JAR \n\n\n\n\n"
"/home/xthan/lluiment/back-LLU/mvnw" package -f "/home/xthan/lluiment/back-LLU/pom.xml"

#MANDAR POR SCP AL SERVIDOR EL .JAR
echo "MANDANDO .JAR \n\n\n\n\n"
scp ~/lluiment/back-LLU/target/lluiment-0.0.1-SNAPSHOT.jar root@170.64.161.75:~/


#PREPARADO ANGULAR

#CONSTRUYENDO EL PROYECTO ANGULAR
cd ~/lluiment/front-LLU
ng build --base-href "https://lluiment.es"
rm -r ~/lluiment/lluiment.es
cp -r ~/lluiment/front-LLU/dist/front-llu/browser ~/lluiment  	 
mv ~/lluiment/browser ~/lluiment/lluiment.es

ssh root@170.64.161.75 "rm -rf /var/www/lluiment.es"
scp -r ~/lluiment/lluiment.es root@170.64.161.75:/var/www/
#scp -r ~/lluiment/back-LLU/mediafiles/* root@170.64.161.75:/var/www/lluiment.es/media/
#PONER EN MARCHA EL SERVIDOR
ssh root@170.64.161.75 "java -jar ~/lluiment-0.0.1-SNAPSHOT.jar"

#COPIANDO DE NUEVO LA CONFIGURACION POR DEFECTO PARA EL TESTEO DE LA APLICACION CON LA CONTRASEÑA PREDETERMINADA
sudo cp ~/lluiment/tiger ~/lluiment/back-LLU/src/main/resources/application.properties
