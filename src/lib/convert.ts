export function toLbs(weight: number): number {
  return Math.round((weight * 2.20462) * 4) / 4
}

export function toKgs(weight: number): number {
  return Math.round((weight / 2.20462) * 4) / 4
}
