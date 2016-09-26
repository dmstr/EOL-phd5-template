planck
======

0 line application template

## Documentation

[Quick start tutorial](https://github.com/dmstr/docs-phd5/blob/master/guide/tutorials/docker-build-from-phd.md) | [Guide](https://github.com/dmstr/docs-phd5/blob/master/guide/README.md)

### Getting started

Create environment config

    cp .env-dist .env

Build images

    docker-compose build
    
Inital setup of application    

    docker-compose run --rm \
        -e APP_ADMIN_PASSWORD=admin1 \
        -e APP_MIGRATION_LOOKUP=@app/migrations/demo-data \
        php yii app/setup
        
Start stack
        
    docker-compose up -d

Open your 

## Demo

http://demo.apptransporter.com.staging-2.oneba.se

![Frontend](https://raw.githubusercontent.com/dmstr/gh-media/master/dmstr/planck/apptransporter-demo-frontend.png)
![Backend](https://raw.githubusercontent.com/dmstr/gh-media/master/dmstr/planck/apptransporter-demo-backend.png)

## Support


## Contribute


## License



## Resources

- links

---

### ![dmstr logo](http://t.phundament.com/dmstr-16-cropped.png) Built with [phd](http://phd.dmstr.io) from [dmstr](http://diemeisterei.de)
