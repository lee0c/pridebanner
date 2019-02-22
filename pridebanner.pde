/* =================================================
SETTINGS
================================================= */
color backdrop = #333333; 

// flag dimensions
int FLAGW = 200;
int FLAGH = 60;

// Set to false if you prefer no fade at the edges of the banner
boolean USE_FADE = true;
int FADEW = 75; // length of gradient to fadeout
int BORDW = 60; // distance between edge & first flag
  // BORDW > FADEW -> edges fade fully to background color
  // FADEW > BORDW -> edges show only partial fadeout
/* =================================================
END SETTINGS
================================================= */

int GRADW, NUMFLAGS; // determined by other vars

// flag stuff
ArrayList<flag> flags = new ArrayList<flag>();

/* Setup */
void setup() {
  size(1500,500);
  background(backdrop);
  noLoop();
  noStroke();

  stripe[] s0 = {
    new stripe(backdrop, 0) };
  flags.add( new flag(0, FLAGH, s0) );

/* =================================================
FLAG SETUP
================================================= */
  // Pansexual flag
  stripe[] s1 = { 
    new stripe(#ff1486, 0),
    new stripe(#ffda00, 20),
    new stripe(#05aeff, 40) };
  flags.add( new flag(FLAGW, FLAGH, s1) );

  // Transgender flag
  stripe[] s2 = { 
    new stripe(#55cdfc, 0),
    new stripe(#f7a8b8, 12),
    new stripe(#ffffff, 24),
    new stripe(#f7a8b8, 36),
    new stripe(#55cdfc, 48) };
  flags.add( new flag(FLAGW, FLAGH, s2) );

  // Rainbow flag
  stripe[] s3 = { 
    new stripe(#e70000, 0),
    new stripe(#ff8c00, 10),
    new stripe(#ffef00, 20),
    new stripe(#00811f, 30),
    new stripe(#0044ff, 40),
    new stripe(#760089, 50) };
  flags.add( new flag(FLAGW, FLAGH, s3) );
/* =================================================
END FLAG SETUP
================================================= */

  flags.add( new flag(0, FLAGH, s0) );

  NUMFLAGS = flags.size() - 2;

  GRADW = (width - NUMFLAGS * FLAGW - BORDW * 2) / (NUMFLAGS - 1);
}

void draw() {
  int x, y, i;
  if (USE_FADE) { 
    x = BORDW - FADEW;
    i = 0;
  } else {
    x = BORDW;
    i = 1; // skip the first "empty" flag
  }
  y = (height - FLAGH) / 2;

  for (; i < flags.size(); i++) {
    // draw the flag
    flag f = flags.get(i);
    f.draw(x, y);
    x += f.w;

    // if we've just drawn the last flag, stop
    if (i == flags.size() - 1) { break; }

    // draw the gradient between this flag and the next
    if (USE_FADE && (i == 0 || i == flags.size() - 2) ) {
      drawFlagGradient(x, y, f, flags.get(i + 1), FADEW);
      x += FADEW;
    } else if (!USE_FADE && (i == 0 || i == flags.size() - 2) ) {
      x += BORDW;
    } else {
      drawFlagGradient(x, y, f, flags.get(i + 1), GRADW);
      x += GRADW;
    }
  }

  save("banner.png");
}

void drawFlagGradient(int x, int y, flag f1, flag f2, int w) {
  int orig_y, s1, s2, f1_next, f2_next, next;
  orig_y = y;
  s1 = 1; // counters for the next stripe coming up in both flags
  s2 = 1;
  
  while (y < orig_y + FLAGH) {
    f1_next = f1.getStripeOffset(s1);
    f2_next = f2.getStripeOffset(s2);
    next = min(f1_next, f2_next) + orig_y;

    setGradient(x, y, x + w, next, f1.getStripeColor(s1 - 1), f2.getStripeColor(s2 - 1));
    y = next;

    if (f1_next < f2_next) {
      // f1's stripe ends first (& was just drawn) - inc. s1
      s1++;
    } else if (f1_next == f2_next) {
      // both stripes end at the same time (& were just drawn) - inc. both
      s1++;
      s2++;
    } else {
      //f2's stripe ends first (& was just drawn) - inc. s2
      s2++;
    }
  }  
}

// Loosely adopted from https://processing.org/examples/lineargradient.html
// Draws a left-to-right gradient from coords (x1,y1) incl. to (x2,y2) exclu.
// in colors c1 -> c2
void setGradient(int x1, int y1, int x2, int y2, color c1, color c2) {
  for (int i = x1; i < x2; i++) {
    float inter = map(i, x1, x2, 0, 1);
    color c = lerpColor(c1, c2, inter);
    fill(c);
    rect(i, y1, i, y2 - y1);
  }
}
