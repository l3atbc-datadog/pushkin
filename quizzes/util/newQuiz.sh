# Run from util directory
set -e
cd ../util/../quizzes/

read -p 'Quiz name: ' QNAME

if [ -d "${QNAME}" ]; then
	echo "A quiz named '${QNAME}' already exists."
	exit
fi

mkdir "${QNAME}"
cd "${QNAME}"
FOLDERS=('api_controllers' 'cron_scripts' 'db_models' 'db_migrations' 'db_seeds' 'quiz_page')
for i in "${FOLDERS[@]}"; do mkdir "$i"; done
cd ..

# add default starting files (names are used by prepareToDeploy.sh!)
# api controller
cp ../util/templates/api_controller/api_controller.js "./${QNAME}/api_controllers/${QNAME}.js"

# db models
cp -r ../util/templates/db_models/* "./${QNAME}/db_models/"

# cron
echo '# contents of this file auto-appended to cron/crontab during build' > "${QNAME}/cron_scripts/crontab.txt"
echo "* 0 0 0 0 root /scripts/${QNAME}/exampleCron.py" >> "${QNAME}/cron_scripts/crontab.txt"
mkdir -p "${QNAME}/cron_scripts/scripts/${QNAME}/"
touch "${QNAME}/cron_scripts/scripts/${QNAME}/exampleCron.py"

# quiz page
sed -e "s/\${QUIZ_NAME}/${QNAME}/" ../util/templates/quiz_page/index.js > "./${QNAME}/quiz_page/index.js"
cp ../util/templates/quiz_page/styles.scss "./${QNAME}/quiz_page/"
