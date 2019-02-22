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
    for (stripe s: stripes) {
      fill(s.c);
      rect(x, y + s.offset, w, h - s.offset);
    }
  }

  /* Get the color for stripe i, or 0 (white) if no stripe i exists */
  color getStripeColor(int i) {
    if (i >= stripes.length) {
      return 0;
    }
    return stripes[i].c;
  }

  /* Get the offset for stripe i, or flag height if no stripe i exists */
  int getStripeOffset(int i) {
    if (i >= stripes.length) {
      return h;
    }
    return stripes[i].offset;
  }
}
