import { describe, it, expect } from 'vitest'

describe('test runner smoke test', () => {
  it('runs in a jsdom environment', () => {
    const el = document.createElement('div')
    el.textContent = 'synthetic'
    document.body.appendChild(el)
    expect(document.body.textContent).toContain('synthetic')
    document.body.removeChild(el)
  })
})
