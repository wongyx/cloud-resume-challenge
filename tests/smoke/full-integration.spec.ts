import { test, expect } from '@playwright/test';
import { getConfig } from '../config/test-config';

const config = getConfig();

test.describe('Cloud Resume - Full Integration Test', () => {
  
  test('Website loads and visitor counter increments', async ({ page }) => {
    console.log('\n📄 Testing full integration...');
    console.log(`Website URL: ${config.websiteUrl}`);
    
    // First visit - this will trigger the first API call via JavaScript
    console.log('\n=== First Visit ===');
    await page.goto(config.websiteUrl, { waitUntil: 'networkidle' });
    
    console.log('✅ Page loaded');
    
    // Wait for the visitor counter element to be visible
    const visitorCount = page.locator('#visitorCount');
    await expect(visitorCount).toBeVisible({ timeout: 10000 });
    console.log('✅ Visitor counter element is visible');
    
    // Wait for the API call to complete and counter to update
    await expect(visitorCount).not.toHaveText('...', { timeout: 10000 });
    console.log('✅ Counter finished loading');
    
    // Get the first count
    const countText1 = await visitorCount.textContent();
    console.log(`First count displayed: "${countText1}"`);
    
    // Verify it's not an error message
    expect(countText1).not.toContain('Error');
    expect(countText1).not.toContain('Unable');
    
    // Parse and validate the count
    const count1 = parseInt(countText1 || '0', 10);
    expect(count1).toBeGreaterThan(0);
    console.log(`✅ Count is a valid number greater than 0: ${count1}`);
    
    // Wait a bit before reload to ensure API has time to process
    await page.waitForTimeout(1000);
    
    // Reload the page - this will trigger the second API call
    console.log('\n=== Second Visit (Reload) ===');
    await page.reload({ waitUntil: 'networkidle' });
    
    // Wait for counter to be visible again
    await expect(visitorCount).toBeVisible({ timeout: 10000 });
    
    // Wait for the second API call to complete
    await expect(visitorCount).not.toHaveText('...', { timeout: 10000 });
    console.log('✅ Counter finished loading on second visit');
    
    // Get the second count
    const countText2 = await visitorCount.textContent();
    console.log(`Second count displayed: "${countText2}"`);
    
    // Verify no error
    expect(countText2).not.toContain('Error');
    expect(countText2).not.toContain('Unable');
    
    const count2 = parseInt(countText2 || '0', 10);
    
    // Verify it incremented by exactly 1
    expect(count2).toBe(count1 + 1);
    console.log(`✅ Count incremented by 1 (${count1} → ${count2})`);
    
    console.log('\n🎉 Full integration test passed!');
    console.log('Summary:');
    console.log('  ✅ Website loads successfully');
    console.log('  ✅ Visitor counter element present');
    console.log('  ✅ First count is valid number > 0');
    console.log('  ✅ Count increments correctly on reload');
  });
});