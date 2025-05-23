const interleave = (arr, thing) =>
  [].concat(...arr.map((n) => [n, thing])).slice(0, -1);

export { interleave };
