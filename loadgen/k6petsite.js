
import { browser } from 'k6/experimental/browser';
import { check } from 'k6';
import http from 'k6/http';

export const options = {
    scenarios: {
        browser: {
            executor: 'constant-vus',
            exec: 'browserTest',
            vus: 4,
            duration: '8h',
            options: {
                browser: {
                    type: 'chromium',
                }
            }
        }
    }
};

export async function browserTest() {
    const page = browser.newPage();

    try {
        await page.goto('http://URI/');

        const submitButton = page.locator('input[value="Search"]');

        await Promise.all([page.waitForNavigation(), submitButton.click()]);

    } finally {
        page.close();
    }
}
