/*
Horizontally striped flag of one to x stripes
*/

public class flag {
  int w;
  int h;
  stripe[] stripes;

  public flag(int w, int h, stripe[] stripes) {
    this.w = w;
    this.h = h;
    this.stripes = stripes;
  }

  /* Draw the flag at the location given */
  void draw(int x, int y) {
    noStroke();
    for (stripe s: this.stripes) {
      fill(s.c);
      rect(x, y, this.w, this.h * s.percent);
      y += this.h * s.percent;
    }
  }

  /* Get the color for stripe i, or 0 (white) if no stripe i exists */
  color getStripeColor(int i) {
    if (i >= this.stripes.length) {
      return 0;
    }
    return this.stripes[i].c;
  }

  /* Get the percent for stripe i, or 0 if no stripe i exists */
  float getStripePercent(int i) {
    if (i >= this.stripes.length) {
      return 0.0;
    }
    return this.stripes[i].percent;
  }
}
