const express = require('express')
const {Builder, By, WebDriver, WebElementCondition, until, Key, WebElement, promise, Chrome} = require('selenium-webdriver');
const chrome = require('selenium-webdriver/chrome')
const chalk = require('chalk')
const bodyParser = require('body-parser');

let driver = new Builder().forBrowser('chrome').build()

var app = express()
app.use(bodyParser.json({ type: 'application/json' }))
app.use(bodyParser.urlencoded({extended: true}))

app.post('/flights', (req, res) => {
    const body = (req.body)
    console.log(body)
    getURL(body[0]).then( () => {
        getPaths(body[0]).then((info) => {
            console.log(info)
            if (info) res.send(info)
            else res.send('Failed to get flights')
        })
    })
})

async function getURL(body) {
    (await driver).get(`https://wizzair.com/#/booking/select-flight/${body.origin}/${body.destination}/${body.departureDate}/null/1/0/0/null`)
}

const server = app.listen(5000, async () => {
    console.log('Server Woke Up')

})

async function getPaths(body) {

    const xpaths = {
        date : '//*[@id="outbound-fare-selector"]/div[3]/div/div/div[1]/div[1]/time',
        duration : '//*[@id="outbound-fare-selector"]/div[3]/div/div/div[1]/div[2]/div[2]/span',
        fromTime: '/html/body/div[2]/div/main/div/div/div[1]/div[2]/div[1]/div[4]/div[3]/div/div/div[1]/div[2]/div[1]/span[1]', 
        toTime: '/html/body/div[2]/div/main/div/div/div[1]/div[2]/div[1]/div[4]/div[3]/div/div/div[1]/div[2]/div[3]/span[1]',
        cost: '/html/body/div[2]/div/main/div/div/div[1]/div[2]/div[1]/div[4]/div[3]/div/div/div[2]/div[1]/div[1]/span'

    }

    let info =  {
        from: body.origin,
        to: body.destination
    }

    for (let [key, value] of Object.entries(xpaths)) {
        var p = await driver.wait(until.elementLocated(By.xpath(value)), 80000) 
        let txt = await p.getText()
        info[key] = txt
    }

    return JSON.stringify([info])
}
  