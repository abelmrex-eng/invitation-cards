# AnimeInvite — Ethiopian 3D Invitation Studio

A responsive, mobile-first invitation website for **Wedding, Birthday (girl/boy), Graduation (girl/boy), Bridal Shower, and Christening (1–4 children, gender per child)**. Built with HTML, CSS and JavaScript; no build step required. Includes 3D artwork cropped from the approved user-provided visual reference, custom SVG avatars, bilingual Unicode text support, live previews, and a CSS 3D envelope reveal.

## Start locally

1. Extract the ZIP, preserving `assets/` beside `index.html`.
2. Open a terminal in the `AnimeInvite_Studio` directory.
3. Run `python -m http.server 8000` (or `npx serve .`).
4. Visit `http://localhost:8000` in Chrome, Safari, or Firefox.
5. Choose an event, edit the invitation, then click **Preview envelope**.

No backend is required to try the builder and animation. This is **not** a production publishing service until Supabase is configured and the website is deployed. Opening the HTML directly as `file://` may restrict ES module loading, so use the local server above.

## Enable real shareable links

1. Create a Supabase project at https://supabase.com.
2. In **SQL Editor**, run `schema.sql`. On reruns, if policies already exist, skip the repeated policy definitions.
3. Under **Authentication → Providers**, enable Email magic links. Under **Authentication → URL Configuration**, add your deployed URL (and local testing URL) to allowed redirect URLs.
4. Copy `config.example.js` to `config.js` and insert your project's **URL** and **publishable/anon key** (never the service-role key).
5. Deploy the entire directory to a static host such as Netlify, Vercel, or GitHub Pages. For GitHub Pages use the correct repository URL; the app uses relative asset paths and URL hashes.
6. Open the site, enter your email, sign in using the email link, fill required fields, and click **Publish invitation**.
7. Copy the generated URL; a guest can open it on another device, and the invitation is loaded from Supabase. Public visitors cannot modify the saved record.

### Security and limitations

- Supabase row-level security allows public reads of **published** invitations and owner-only writes. The prototype has no in-app post-publish editor yet; the data model supports future owner-only editing.
- Uploaded photos (5 MB max) and MP3s (10 MB max) use **public storage URLs** for guest playback. Do not upload private or sensitive media. For production, consider private buckets with signed links, rate limits, moderation, and abuse protection.
- Browser playback starts only after the guest taps **Open invitation**. Some browsers may still require a second tap.
- The music selector supports no music or an uploaded MP3. A licensed Ethiopian music library and configurable default tracks require the owner to supply licensed audio and add the corresponding catalogue/backend support; no copyrighted music is bundled.
- The original 3D character illustrations are raster artwork and **cannot have skin tone or hairstyle edited independently**. Switch to **Custom avatars** for functional skin, hair color, hairstyle, and outfit color changes. The custom avatars are simple SVG illustrations, not 3D models.
- The envelope is a layered CSS 3D animation (flap, shadow, and rising card), not a physically simulated 3D scene. Reduced-motion users receive an immediate reveal; a skip button is available.
- Invitation images were cropped from the approved collage, so some original typography or decorative details may remain visible in gallery art. Names and details in the actual card are live editable text.
- UTF-8 and Noto Sans Ethiopic are used to support Amharic text. Network access is required to load the web fonts; local system fallbacks are provided.

## Files

- `index.html` — entire responsive app and reveal logic.
- `assets/*.webp` — artwork extracted from the user-provided reference.
- `schema.sql` — Supabase tables, RLS, and storage policies.
- `config.example.js` — backend configuration template.

## Suggested next production enhancements

Add a protected dashboard to list, edit, unpublish, and delete the host's invitations; separate public-safe payloads from host-private metadata; use signed storage URLs and quotas; add server-side validation; create a licensed audio catalogue and defaults; and replace static character crops with original editable layered 3D assets.
