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
flag rainbow, lesbian, bi, pan, ace, aro, trans;
flag nonbinary, genderqueer, genderfluid, agender;

/* Setup */
void setup() {
  size(1500, 500);
  background(backdrop);
  noLoop();
  noStroke();

  defineFlags();

  stripe[] s0 = {
    new stripe(backdrop, 1.0) };
  flags.add( new flag(0, FLAGH, s0) );

/* =================================================
FLAG SETUP
options: rainbow, bi, pan, ace, aro, trans, 
  nonbinary, genderqueer, genderfluid
  agender & lesbian/lipstick lesbian flags are coded 
  in but doesn't play nice with integer pixel values
================================================= */
  flags.add(pan);
  flags.add(trans);
  flags.add(rainbow);
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
  int orig_y, s1, s2;
  orig_y = y;
  s1 = s2 = 0; // counters for the next stripe coming up in both flags

  float f1_next, f2_next, h;
  f1_next = f1.getStripePercent(s1) * FLAGH; // height offset from y at which the next stripe occurs
  f2_next = f2.getStripePercent(s2) * FLAGH;
  
  while (y < orig_y + FLAGH) {
    System.out.println(y + f1_next);
    System.out.println(y + f2_next);
    System.out.println();

    h = min(f1_next, f2_next);

    setGradient(x, y, w, int(h), f1.getStripeColor(s1), f2.getStripeColor(s2));
    y += h;

    f1_next -= h;
    f2_next -= h;

    if (f1_next == 0) { f1_next = f1.getStripePercent(++s1) * FLAGH; }
    if (f2_next == 0) { f2_next = f2.getStripePercent(++s2) * FLAGH; }
  }  
}

// Loosely adopted from https://processing.org/examples/lineargradient.html
// Draws a left-to-right gradient from coords (x,y) incl. with width & height w, h
// in colors c1 -> c2
void setGradient(int x, int y, int w, int h, color c1, color c2) {
  for (int i = x; i < x + w; i++) {
    float inter = map(i, x, x + w, 0, 1);
    color c = lerpColor(c1, c2, inter);
    fill(c);
    rect(i, y, 1, h);
  }
}

void defineFlags() {
  // Rainbow flag
  stripe[] s1 = { 
    new stripe(#e70000, 1.0/6),
    new stripe(#ff8c00, 1.0/6),
    new stripe(#ffef00, 1.0/6),
    new stripe(#00811f, 1.0/6),
    new stripe(#0044ff, 1.0/6),
    new stripe(#760089, 1.0/6) };
  rainbow = new flag(FLAGW, FLAGH, s1);

  // Lesbian flag
  // these floats do not like making nice ints
  stripe[] s2 = { 
    new stripe(#a40061, 1.0/7),
    new stripe(#675592, 1.0/7),
    new stripe(#d063a6, 1.0/7),
    new stripe(#ededeb, 1.0/7),
    new stripe(#e4accf, 1.0/7),
    new stripe(#c54e54, 1.0/7),
    new stripe(#8a1e04, 1.0/7) };
  lesbian = new flag(FLAGW, FLAGH, s2);

  // Bi flag
  stripe[] s3 = { 
    new stripe(#d60270, 2.0/5),
    new stripe(#9b4f96, 1.0/5),
    new stripe(#0038a8, 2.0/5) };
  bi = new flag(FLAGW, FLAGH, s3);

  // Pansexual flag
  stripe[] s4 = { 
    new stripe(#ff1486, 1.0/3),
    new stripe(#ffda00, 1.0/3),
    new stripe(#05aeff, 1.0/3) };
  pan = new flag(FLAGW, FLAGH, s4);

  // Ace flag
  stripe[] s5 = { 
    new stripe(#000000, 1.0/4),
    new stripe(#a3a3a3, 1.0/4),
    new stripe(#ffffff, 1.0/4),
    new stripe(#800080, 1.0/4) };
  ace = new flag(FLAGW, FLAGH, s5);

  // Aro flag
  stripe[] s6 = { 
    new stripe(#3da542, 1.0/5),
    new stripe(#a7d379, 1.0/5),
    new stripe(#ffffff, 1.0/5),
    new stripe(#a9a9a9, 1.0/5),
    new stripe(#000000, 1.0/5) };
  aro = new flag(FLAGW, FLAGH, s6);

  // Transgender flag
  stripe[] s7 = { 
    new stripe(#55cdfc, 1.0/5),
    new stripe(#f7a8b8, 1.0/5),
    new stripe(#ffffff, 1.0/5),
    new stripe(#f7a8b8, 1.0/5),
    new stripe(#55cdfc, 1.0/5) };
  trans = new flag(FLAGW, FLAGH, s7);

  // Nonbinary flag
  stripe[] s8 = { 
    new stripe(#fff430, 1.0/4),
    new stripe(#ffffff, 1.0/4),
    new stripe(#9c59d1, 1.0/4),
    new stripe(#000000, 1.0/4) };
  nonbinary = new flag(FLAGW, FLAGH, s8);

  // Genderqueer flag
  stripe[] s9 = { 
    new stripe(#b57edc, 1.0/3),
    new stripe(#ffffff, 1.0/3),
    new stripe(#4a8123, 1.0/3) };
  genderqueer = new flag(FLAGW, FLAGH, s9);

  // Genderfluid flag
  stripe[] s10 = { 
    new stripe(#ff75a2, 1.0/5),
    new stripe(#ffffff, 1.0/5),
    new stripe(#be18d6, 1.0/5),
    new stripe(#000000, 1.0/5),
    new stripe(#333ebd, 1.0/5) };
  genderfluid = new flag(FLAGW, FLAGH, s10);

  // Agender flag
  stripe[] s11 = { 
    new stripe(#000000, 1.0/7),
    new stripe(#b9b9b9, 1.0/7),
    new stripe(#ffffff, 1.0/7),
    new stripe(#b8f483, 1.0/7),
    new stripe(#ffffff, 1.0/7),
    new stripe(#b9b9b9, 1.0/7),
    new stripe(#000000, 1.0/7) };
  agender = new flag(FLAGW, FLAGH, s11);
}
