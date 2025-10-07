#!/bin/bash

# -------------------------------------------------------
# Programme de test en boîte noire pour les 13 allumettes
# -------------------------------------------------------

usage() {
	echo "Erreur : $1"
	echo
	echo "Usage : sh testeur.sh [-d dossier] fichier.run..."
	exit 1
}

warning() {
	echo "**** $1" 1>&2
}

mainFile=allumettes.adb
exeFile=$(basename ${mainFile} .adb)

# Déterminer le dossier des sources
if [ ! -f $mainFile ] ; then
    usage "Pas de fichier $mainFile.\nIl faut être dans le dossier qui contient $mainFile."
elif [ ! -r $mainFile ] ; then
    usage "Pas d'accès en lecture sur $mainFile."
fi

# Traiter les arguments de la ligne de commande
# | Un seul argument possible -d pour déterminer le dossier dans lequel
# | mettre les résutlats du test (.out et .diff)
if [ "$1" = "-d" ] ; then
	shift
	testdiropt="$1"
	shift
	if [ ! -d "$testdiropt" ] ; then
		usage "$testdiropt n'est pas un dossier"
	elif [ ! -w "$testdiropt" ] ; then
		usage "impossible d'écrire dans $testdiropt"
	fi
fi

if [ ! -z "$testdiropt" ] ; then
	echo "Les résultats seront dans $testdiropt."
fi


# Jouer les tests
if gnatmake -gnatwa -gnata $mainFile ; then
    while [ "$1" ] ; do
	test="$1"
	shift

	if [ ! -f "$test" ] ; then
		warning "Fichier de test inexitant : $test"
		continue
	elif [ ! -r "$test" ] ; then
		warning "Fichier de test interdit en lecture : $test"
		continue
	fi

	testName=$(basename "$test" .run)
	testBasename=$(basename "$test")
	outputDir=${testdiropt:-$(dirname "$test")}

	if [ "$testName" = "$testBasename" ] ; then
		warning "Test ignoré (le suffixe doit être .run) : $test"
		continue
	fi


	# Définir les noms de fichiers utilisés
	out=$outputDir/$testName.out
	expected=${test%.run}.expected
	diff=$outputDir/$testName.diff


	if [ ! -r "$expected" ] ; then
		warning "Fichier de résultat absent ou interdit en lecture : $expected"
		continue
	fi

	# Lancer le test
	sh $test > $out 2>&1

	# Transformer le résultat en utf8 (si nécessaire)
	if file -i $out | grep iso-8859 > /dev/null 2>&1 ; then
	    echo "Résultat en latin1.  Je transforme en utf8."
	    if command -v recode > /dev/null ; then
		recode latin1..utf8 $out
	    elif command -v iconv > /dev/null ; then
		iconv -f latin1 -t utf8 $out > $out.utf8
		mv $out.utf8 $out
	    else
		echo "... Pas de commande pour faire la conversion :-(."
	    fi
	fi

	# Afficher le résultat
	echo -n "$testName : "
	if diff -Bbw $out $expected > $diff 2>&1 ; then
	    echo "ok"
	else
	    echo "ERREUR"
	    cat $diff
	    echo ""
	fi
    done
else
    echo "Erreur de compilation !"
fi
