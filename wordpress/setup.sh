if [ -z "$1" ]; then title="Project"; else title=$1; fi
if [ -z "$2" ]; then theme="genesis-sample"; else theme=$2; fi

wp core download --locale=en_GB --skip-content
wp config create --dbname=wordpress --dbuser=root --dbhost=127.0.0.1 --extra-php="define( 'WP_POST_REVISIONS', false );" --skip-check
wp core install --url=localhost:8080 --title=${title} --admin_user=project --admin_password=project --admin_email=contact@project.co --skip-email
wp theme install $(dirname $0)/themes/genesis.zip
wp theme install $(dirname $0)/themes/${theme}.zip --activate && wp genesis upgrade-db
wp plugin install genesis-simple-edits ninja-forms no-category-base-wpml wordpress-importer --activate
wp language core update

wp rewrite structure /%postname%
wp option update blogdescription ""
wp option update timezone_string Europe/Berlin
wp option update time_format H:i
wp option update uploads_use_yearmonth_folders 0 && rm -r ./wp-content/uploads/*
wp user meta update 1 show_welcome_panel 0
wp user meta update 1 metaboxhidden_dashboard '["dashboard_primary"]' --format=json

wp term update category 1 --name=Blog --slug=blog
wp widget delete $(wp widget list sidebar --format=ids)
wp post delete 1 2 3 --force
wp import $(dirname $0)/content.xml --authors=create && wp plugin delete wordpress-importer

wp menu location assign menu primary
wp option patch update genesis-settings footer_text '[footer_copyright] '${title}' · <a href="/privacy">Privacy</a> · <a href="/legal">Legal</a>'
wp option update gse-settings '{"post_info":"[post_date] · [post_author_posts_link] [post_comments] [post_edit]"}' --format=json
wp option patch insert gse-settings post_meta '[post_categories before=""] [post_tags before=""]'

wp eval '$form = Ninja_Forms()->form( 1 )->get(); $form->delete();'
wp eval '$form = file_get_contents( "'$(dirname $0)'/form.json" ); Ninja_Forms()->form()->import_form( $form );'
wp option update ninja_forms_do_not_allow_tracking 1
wp option update nf_admin_notice '{"one_week_support":{"dismissed":1}}' --format=json
wp post create --post_type=custom_css --post_author=1 --post_status=publish --post_title=${theme} --post_content=".ninja-forms-req-symbol, .nf-field-element:after {display: none;}"

if [ "$3" = "de" ]
then
  wp language core install de_DE --activate
  wp plugin install genesis-translations --activate
  wp option patch update genesis-settings footer_text '[footer_copyright] '${title}' · <a href="/datenschutz">Datenschutz</a> · <a href="/impressum">Impressum</a>'
fi
