planck
======

Web application template built from `dmstr/phd5-app`

## Documentation

[Quick start tutorial](http://phd.dmstr.io/en/docs/guide/tutorials/quick-start-planck.md) 
| [Guide](https://github.com/dmstr/docs-phd5/blob/master/guide/README.md)

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

Login with `admin` / `admin1`    

## Resources

- :octocat: [Source-code on GitHub](https://github.com/dmstr/planck)
- :wolf: [Source-code on git.hrzg.de](https://git.hrzg.de/dmstr/planck)
- :cd: [Base-image phd5](https://github.com/dmstr/phd5-app)
- :cd: :credit_card: [Base image phd5-ee](https://git.hrzg.de/hrzg/phd5-ee-app)
- :green_book: [Documentation](https://github.com/dmstr/docs-phd5/blob/master/README.md)

---

### ![dmstr logo](http://t.phundament.com/dmstr-16-cropped.png) Built with [phd](http://phd.dmstr.io) from [dmstr](http://diemeisterei.de)
