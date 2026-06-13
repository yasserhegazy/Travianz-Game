const { chromium } = require('playwright');
(async () => {
  const browser = await chromium.launch();
  const context = await browser.newContext({
    viewport: { width: 375, height: 812 },
    isMobile: true,
    hasTouch: true
  });
  const page = await context.newPage();
  await page.goto('http://localhost:8080/login.php', { waitUntil: 'networkidle' });
  await page.screenshot({ path: 'login_mobile.png', fullPage: true });
  await page.goto('http://localhost:8080/anmelden.php', { waitUntil: 'networkidle' });
  await page.screenshot({ path: 'register_mobile.png', fullPage: true });
  await browser.close();
  console.log("Screenshots captured");
})();
