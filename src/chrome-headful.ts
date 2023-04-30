import { launch } from "chrome-launcher";
import puppeteer from "puppeteer-core";
import tmp from "tmp";

export const handler = async () => {
  const chrome = await launch({
    chromeFlags: [
      "--window-size=1366,768",
    ] /** We don't need to use --headless flag :) */,
    ignoreDefaultFlags: true,
    port: 9222,
    userDataDir: tmp.dirSync().name,
  });

  const browser = await puppeteer.connect({
    browserURL: "http://127.0.0.1:9222",
  });

  const page = await browser.newPage();

  await page.goto("https://api.ipify.org?format=json");

  const content = await page.content();

  browser.disconnect();
  await chrome.kill();

  return { content };
};

if (!process.env.AWS_LAMBDA_RUNTIME_API) {
  Promise.resolve().then(handler);
}
