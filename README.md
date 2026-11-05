# Collage Desk

[![Netlify Status](https://api.netlify.com/api/v1/badges/33b7ba72-4f8c-49bf-a080-e9eaf4888e5d/deploy-status)](https://app.netlify.com/projects/collage-desk/deploys)

A scrapbook-style notes site. Each page is a free canvas where you can drop notes, pictures, stickers, washi tape and punch cards, drag them anywhere, and layer them however you like. It opens with an envelope that slides out a sign-in card.

**Live site:** https://collage-desk.netlify.app

## Features

- **Pages as tabs.** Each tab is its own board. Start one blank, or from one of three layouts: canvas collage, magazine spread, or punch cards.
- **Paper styles.** Polka dot, canvas, magazine, gingham or grid background for each page, plus an optional print grain over everything.
- **Things to add:**
  - notes, labels, headlines and handwritten scribbles in six fonts
  - pictures as plain images, postcards or polaroids, with color tints, tape and a "print" blend
  - a sticker drawer of paper scraps, frames, butterflies, buttons and glossy shapes
  - punch cards for habits: tap a shape to punch it
  - washi tape in stripes, dots or check
- **Paste or drop images** from anywhere. "Cut out" removes a white background, and "Save as sticker" keeps the result in your drawer.
- **Editing tools:**
  - drag to move, the corner dot to resize, the top dot to rotate
  - layer items forward and back
  - drag a box to select several items, then move, duplicate or delete them together
  - undo and redo for each page
  - pinch to zoom, or use the zoom buttons and "Fit"
  - full screen mode
- **Accounts.** Sign in with an email or a username. Every person's boards and pictures are private to them and sync across devices.

## How it's built

- One page (`index.html`) of plain HTML, CSS and JavaScript. No framework and no build step.
- [Supabase](https://supabase.com) handles sign-in, the database and picture storage.
- [Netlify](https://netlify.com) hosts the site.
- Fonts come from Google Fonts: Instrument Serif, DM Sans, Courier Prime, Caveat, Pinyon Script and Bricolage Grotesque.

### Files

All files sit at the top of the repo:

```
index.html            the whole app
netlify.toml          tells Netlify to publish the files as they are
supabase-setup.sql    database tables, privacy rules and picture storage
supabase.js           the Supabase browser library (supabase-js 2.45.4)
591.supabase.js       part of the Supabase library
back.webp, bg.png, flap.webp, paper.webp, pocket.webp, stars.webp
                      envelope layers for the sign-in animation
everything else .webp images for the sticker drawer
```

## Setting it up yourself

1. **Create a Supabase project.** In the SQL Editor, run `supabase-setup.sql`. It creates:
   - `pages`: one row per board page
   - `settings`: page order, grain setting and saved stickers
   - `pictures`: a private storage bucket

   Row level security limits every row and picture to the person who made it.
2. **Set up sign-in.** Go to **Authentication → Sign In / Providers → Email**. Turn Email on and turn **Confirm email** off. Username accounts use a hidden placeholder email address, so they can't receive confirmation emails.
3. **Connect the site to your project.** Near the top of the script in `index.html`, change `SB_URL` and `SB_KEY` to your Project URL and **publishable** key. The publishable key is meant to be public. Never put the secret key or the database password in this repo.
4. **Deploy.** Connect this repo to Netlify with no build command and `.` as the publish directory. You can also drag the folder onto Netlify Drop.
5. **Tell Supabase where the site lives.** In **Authentication → URL Configuration**, add your site address as the Site URL and as a Redirect URL.

## Good to know

- Username accounts can't reset a forgotten password, because there's no real email to send a reset link to. The sign-in card tells people this.
- On Supabase's free plan, projects pause after a week with no activity. If sign-in stops working, open the Supabase dashboard and restore the project.
- The built-in Supabase email service sends only a few emails per hour. Confirmation and password-reset emails need a custom SMTP provider.

## Credits

The sticker images, the envelope and background on the sign-in screen, and the reference palette came from Pinterest. They belong to their original creators and are used here for personal, non-commercial purposes only. Swap them for your own artwork before reusing this project publicly.

The Supabase JavaScript library (`supabase.js`, `591.supabase.js`) is MIT licensed.
