const puppeteer = require('puppeteer');

(async () => {
  console.log('Starting Puppeteer with chrome-headless-shell...');

  const browser = await puppeteer.launch({
    headless: true,
    args: ['--no-sandbox', '--disable-setuid-sandbox'],
  });

  const page = await browser.newPage();
  console.log('Browser launched, navigating to example.com...');

  await page.goto('https://example.com', { waitUntil: 'networkidle0' });

  const title = await page.title();
  console.log(`Page title: "${title}"`);

  const bodyText = await page.$eval('body', el => el.innerText.slice(0, 200));
  console.log(`Page body (first 200 chars): "${bodyText}"`);

  await browser.close();
  console.log('SUCCESS: Puppeteer with chrome-headless-shell works correctly.');
})().catch(err => {
  console.error('FAILED:', err.message);
  process.exit(1);
});
