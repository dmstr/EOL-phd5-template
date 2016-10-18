planck
======

Web application template built from `dmstr/phd5-app`

## Documentation

[Quick start tutorial](https://github.com/dmstr/docs-phd5/blob/master/guide/tutorials/docker-build-from-phd.md) | [Guide](https://github.com/dmstr/docs-phd5/blob/master/guide/README.md)

### Getting started

Update `Dockerfile`.

Create environment config

    cp .env-dist .env
    
Create application `src/local.env`, if needed.    

Build images

    docker-compose build
    
Inital setup of application    

    docker-compose run --rm \
        -e APP_ADMIN_PASSWORD=admin1 \
        -e APP_MIGRATION_LOOKUP=@app/migrations/demo-data \
        php yii app/setup
        
Start stack
        
    docker-compose up -d

Open your browser
 
    open http://$DOCKER_HOST_IP:21080
    

---

### ![dmstr logo](http://t.phundament.com/dmstr-16-cropped.png) Built with [phd](http://phd.dmstr.io) from [dmstr](http://diemeisterei.de)
