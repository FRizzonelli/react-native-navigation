import * as _ from 'lodash';

describe('test environment', () => {
  it('handles object spread', () => {
    const { x, y, ...z } = { x: 1, y: 2, a: 3, b: 4 };
    expect(x).toEqual(1);
    expect(y).toEqual(2);
    expect(z).toEqual({ a: 3, b: 4 });
  });

  it('handles async await', async () => {
    const result = await new Promise((r) => r('hello'));
    expect(result).toEqual('hello');
  });

  it('lodash equality tests', () => {
    expect(_.eq('hello', 'hello')).toBe(true);
    expect(_.isEqual('hello', 'hello')).toBe(true);

    expect(_.eq('hello', Object('hello'))).toBe(false);
    expect(_.isEqual('hello', Object('hello'))).toBe(true);

    const a = {};
    const b = {};

    expect(_.eq(a, b)).toBe(false);
    expect(_.isEqual(a, b)).toBe(true);
  });
});
