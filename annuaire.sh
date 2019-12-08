#!/bin/bash


#Fonction principal qui affiche le menu de l'annuaire
main(){

echo "Bienvenu dans l'application de gestion d'annuaire !"
echo "Voulez vous gérer l'annuaire ?  :"
read reponse

while [ $reponse == "oui" ]
do
echo "Enregistrer une personne : 1"
echo "Rechercher une personne : 2"
echo "Supprimer une personne : 3"
echo "Afficher l'annuaire : 4"
echo "Trier l'annuaire : 5"
read choix

case $choix in
	"1") enregistrer 
	echo "Voulez vous gérer l'annuaire ?  :"
	read reponse;;
	"2") chercher
	echo "Voulez vous gérer l'annuaire ?  :"
        read reponse;;
	"3")supprimer
	echo "Voulez vous gérer l'annuaire ?  :"
        read reponse;;
	"4") afficher annuaire.txt 
	echo "Voulez vous gérer l'annuaire ?  :"
        read reponse;;
	"5") tri annuairetrie.txt
	echo "Voulez vous gérer l'annuaire ? :"
	read reponse;;


	*) echo "A bientôt !";;
esac
done
}

#Fonction pour afficher les personnes de l'annuaire
function afficher(){

echo $info

#parcours du fichier pour afficher les personnes
cat $1 | while read ligne ; do

echo $ligne > affichage.txt

nom=$( cut -d: -f 1 affichage.txt )
prenom=$(  cut -d: -f 2  affichage.txt )
adresse=$( cut -d: -f 3  affichage.txt )
codep=$( cut -d: -f 4 affichage.txt )
ville=$( cut -d: -f 5 affichage.txt )

echo "Nom :" $nom
echo "Prenom : " $prenom 
echo "Adresse : " $adresse
echo "Code Postal : " $codep
echo "Ville : " $ville

echo "-------------------"

done 

}

#Fonction pour trier la liste dans l'annuaire soit par nom ou par code postal
function tri(){

echo "Voulez vous trier par nom ou par code postal ?"
read reponse

#Trier par nom
if [ $reponse == "nom" ]
then

	sort annuaire.txt > annuairetrie.txt
	echo $1

	afficher annuairetrie.txt
#Trier par code postal
elif [ $reponse == "postal" ]
then

	sort -t : -k 4  annuaire.txt > annuairetrie.txt

	afficher annuairetrie.txt


else
	echo " reponse invalide !"


fi

}

#Fonction pour enregistrer une personnes avec ces informations
function enregistrer(){

local var

touch  annuaire.txt

echo "Votre nom :"
read var
echo "$var:" | tr -d "\n" >> annuaire.txt
echo "Votre prénom :"
read var
echo "$var:" | tr -d "\n" >> annuaire.txt
echo "Votre adresse :"
read var
echo "$var:" | tr -d "\n" >> annuaire.txt
echo "Votre code postal :"
read var
echo "$var:" | tr -d "\n" >> annuaire.txt
echo "Votre ville :"
read var
echo "$var"  >> annuaire.txt

}

#Fonction pour rechercher une personne
function chercher(){

local nom
local personnes
local nblignes
local prenom

echo "Le nom de la personne à trouver :"
read nom

touch personnes.txt

grep $nom annuaire.txt > personnes.txt

nblignes=$(cat personnes.txt | wc -l) 

echo $nblignes
#On commence par vérifier s'il existe des doublons de noms
if [ $nblignes -gt 1 ]
then
	echo " il existe des doublons, donner le prénom de la personne : "
	read prenom

	grep $prenom personnes.txt > personnes2.txt
	cat personnes2.txt > personnes.txt
	nblignes=$(cat personnes.txt | wc -l)
	echo $nblignes
	#Vérification de personnes ayant le même nom
	if [ $nblignes -gt 1 ]
	then
		echo " Il existe des doublons de prénoms, donner le code postal :"
		read codep

		grep $codep personnes.txt > personnes2.txt
        	cat personnes2.txt > personnes.txt
        	nblignes=$(cat personnes.txt | wc -l)
        	echo $nblignes
	#Vérification de personnes ayant le même code postal
		 if [ $nblignes -gt 1 ]
      		 then
                        echo " Il existe des doublons de codepostal, donner la ville :"
                        read ville

                        grep $ville personnes.txt > personnes2.txt
                        cat personnes2.txt > personnes.txt
                        nblignes=$(cat personnes.txt | wc -l)
                        echo $nblignes
			if [ $nblignes -eq 1 ]
			then
				afficher personnes.txt
			fi

			if [ $nblignes -eq 0 ]
                        then
                               echo " Aucune personne trouvé"
                        fi

        	elif [ $nblignes -eq 1 ]
        	then

			afficher personnes.txt

        	else
                        echo " aucune personne trouvé "
                        echo $nblignes
        	fi

	elif [ $nblignes -eq 1 ]
	then

		afficher personnes.txt

	else
			echo "aucune personnes dans l'annuaire !"
			echo $nblignes
	fi

#S'il existe personne de ce nom
elif [ $nblignes -eq 0 ]
then
	echo "il n'existe personne de nom " $nom
#S'il existe une personne de ce nom
elif [ $nblignes -eq 1 ]
then

	afficher personnes.txt
else
	echo "fin"
fi

}

#Fonction pour supprimer une personne de l'annuaire
function supprimer(){

echo "Nom de la personne à supprimer :"
read nom

touch personnesupp.txt

grep $nom annuaire.txt > personnesupp.txt

nblignes=$(cat personnesupp.txt | wc -l) 

echo $nblignes

if [ $nblignes -gt 1 ]
then
	echo " Existe doublon donner le prénom de la personne à supprimer :"
	read prenom

        grep $prenom personnesupp.txt > personnesupp2.txt
	cat personnesupp2.txt > personnesupp.txt

	nblignes=$( cat personnesupp.txt | wc -l )
	echo $nblignes

	if [ $nblignes -gt 1 ]
	then
		echo "Il existe des doublons de prénoms, donner le code postal :"
		read codep

		grep $codep personnesupp.txt > personnesupp2.txt
        	cat personnesupp2.txt > personnesupp.txt

        	nblignes=$( cat personnesupp.txt | wc -l )
        	echo $nblignes

		if [ $nblignes -gt 1 ]
		then
			echo "Il existe des doublons de code postal, donner la ville :"
                	read ville

                	grep $ville personnesupp.txt > personnesupp2.txt
                	cat personnesupp2.txt > personnesupp.txt

                	nblignes=$( cat personnesupp.txt | wc -l )
                	echo $nblignes

			if [ $nblignes -eq 1 ]
                	then
				grep -v $ville annuaire.txt > annuaire2.txt
                        	cat annuaire2.txt > annuaire.txt
                        	echo "Voici l'annuaire après la suppression de " $nom
                        	afficher annuaire.txt
			fi

			if [ $nblignes -eq 0 ]
			then
				echo "aucune personnes dans l'annuaire !"
			fi

		elif [ $nblignes -eq 1 ]
		then

			grep -v $codep annuaire.txt > annuaire2.txt
        		cat annuaire2.txt > annuaire.txt
        		echo "Voici l'annuaire après la suppression de " $nom
        		afficher annuaire.txt

		else
			echo " Aucune personne dans l'annuaire !"
		fi

	elif [ $nblignes -eq 1 ]
	then

	grep -v $prenom annuaire.txt > annuaire2.txt
	cat annuaire2.txt > annuaire.txt
	echo "Voici l'annuaire après la suppression de " $prenom 
	afficher annuaire.txt

	else
		echo "Aucune personnes trouvé !"
	fi

elif [ $nblignes -eq 1 ]
then
        grep -v $nom annuaire.txt > annuaire2.txt
	echo "Voici l'annuaire après la suppression de " $nom 
        cat annuaire2.txt > annuaire.txt
        afficher annuaire.txt

else
        echo " Aucune personnes de ce nom : "$nom
fi

}


#help pour les fonctions

case $1 in
	-e)  echo "La fonction enregistrer permet d'enregistrer une personne dans l'annuaire";;
	-s)  echo "La fonction supprimer permet de supprimer une personne de l'annuaire, elle vérifie s'il existe des doublons";;
	-a)  echo "La fonction afficher permet d'afficher les détails d'une personne";;
	-t) echo "La fonction tri permet de trier la liste de personne dans l'annuaire, soit par nom ou par code postal selon le choix de l'utilisateur (nom/postal) ";;
	-c)echo "La fonction chercher permet de rechercher une personne dans l'annuaire et l'afficher, elle vérifie s'il existe des doublons ";;
	*) main ;;
esac



