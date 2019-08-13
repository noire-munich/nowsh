#/usr/bin

raise__path=$nowpath/lib/Raise;

Raise()
{
    Raise__main $@;
}

Raise__setup_symfony()
{
    cd $2 && composer create-project symfony/skeleton . -s dev;
}

Raise__setup_react()
{
    cd $1;
    npm install @material-ui/core @material-ui/icons react-dom react-router;
    npm install --save-dev babel-core babel-loader babel-preset-react;
    npm install --save-dev webpack webpack-dev-server html-webpack-plugin;
    create-react-app pub;
    cd pub && npm start;
}

Raise__setup_docker()
{
    ## Docker
    #cp $raise__path/files/docker/* /Workspace/Code/$1;

}

Raise_setup_nginx()
{
    ## Source template: https://www.nginx.com/resources/wiki/start/topics/recipes/symfony/
    #SERVERNAME PATH
    servername="$1.sf4.local";
    if [ ".local" != $servername ];
    then
        if [ -d $2 ];
        then
            awkcommand='{
    gsub(/SERVERNAME/, servername);
    gsub(/PATH/, path);
    print;
}
'
            awk -v servername="$servername" \
                -v path="$2/www/public" \
                $awkcommand $raise__path/files/nginx/default.sf4.conf \
                >> /Workspace/Code/nginx.conf.d/$1.sf4.conf
        fi;
    fi;
}

Raise__create()
{
    cd /Workspace/Code;
    if [ ! -d /Workspace/Code/$1 ];
    then
        mkdir -p /Workspace/Code/$1/{www,sql};
        cd /Workspace/Code/$1 && echo "Created.";
        apppath=/Workspace/Code/$1;
        ## Nginx
        Raise_setup_nginx $1 $apppath;
        ## Docker
        #Raise__setup_docker $apppath;
        ## Symfony
        #return;
        Raise__setup_symfony "$1" "$apppath/www"
        return;
        ## React
        #Raise__setup_react $apppath
    fi;
}

Raise__main()
{
    p=$(find /Workspace/Code -maxdepth 2 -type d -iname "*$1*" | head -n 1);
    if [ -d $p/www ];
    then
        echo "Project exists: not raising anything.";
        return;
        ## Here logic to docker up!
        # docker run 4000:80 $1
    else
        Raise__create $1;
    fi;

}