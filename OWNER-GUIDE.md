# Invitation site owner guide

This is how the site works now, and how you (the owner) change it. Anyone can make an account and create their own wedding, birthday, graduation, bridal shower or christening invitation. Only you can change the website itself.

## Who can do what

- **You (owner):** you change the website, its pictures and its songs through your GitHub repo (invitation-cards). Only your GitHub account can commit there, so nobody else can edit the site. You also own the Supabase project, where you can see every account and invitation (Table Editor > invitations).
- **Visitors:** they sign up with an email and password, then create, save, edit and delete their own invitations. The database rules stop anyone from seeing drafts, editing or deleting an invitation that isn't theirs.
- **Guests:** they open an invitation link. They can only read published invitations.

## Put this update live

1. In GitHub, open your invitation-cards repo. Click **Add file**, then **Upload files**.
2. Drag in **index.html**, **OWNER-GUIDE.md**, **schema.sql** and the whole **music** folder (five MP3 files). Commit.
3. Leave **config.js** alone. Yours already has your Project URL and publishable key.
4. In Supabase, open **SQL Editor**, click **New query**, paste everything from schema.sql and click **Run**. It is safe to run more than once.
5. In Supabase, open **Authentication > Sign In / Providers** and make sure **Email** is on.
6. In Supabase, open **Authentication > URL Configuration**. Set **Site URL** to https://abelmrex-eng.github.io/invitation-cards/ so the confirmation and password reset emails send people back to your site.
7. Wait a minute, then hard refresh the site (Ctrl+Shift+R).

## Accounts and passwords

People click **Create account** with an email and password. Supabase Auth stores the password on the backend in hashed form, so nobody (you included) can read it, and it is never in the website's files. If email confirmation is on (the Supabase default), they confirm by email first, then sign in. **Forgot password?** emails them a link to set a new one.

## Invitations in the database

- **Save draft** stores the invitation in the database without making a link.
- **Publish invitation** stores it and gives a link to send.
- **My invitations** (shown after signing in) lists every saved invitation with **Edit**, **View**, **Copy link** and **Delete**.
- To change the date, time or location after sending, press **Edit**, change it, then **Save changes for everyone**. The link stays the same, and every guest sees the new details the next time they open it.
- **Delete** removes the invitation and its uploaded picture. The link stops working.
- Pictures go to Supabase Storage (the invitation-images bucket) as soon as a signed-in person picks one, and the picture's link is saved with the invitation.

## Songs

Visitors can't upload songs. They choose from the site's songs, one per celebration, and can press **Hear the song** to listen while they fill in the card. The five songs now in the music folder are temporary samples I made from scratch for the site (original, no copyright issues).

To replace a song, upload your MP3 into the **music** folder in GitHub with exactly the same file name, and commit:

- music/wedding.mp3
- music/birthday.mp3
- music/graduation.mp3
- music/bridal.mp3
- music/christening.mp3

Only use music you have the rights to share on a public website. If a file is missing, its song shows as "not added yet" and can't be picked.

## Changing anything else

Open the file in GitHub, click the pencil to edit, and commit. Changes show on the live site a minute or two later.
