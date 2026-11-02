ZII DIGITAL STORE - SETUP GUIDE
================================

FILES
- index.html: Storefront and admin dashboard interface
- style.css: Black-and-gold luxury design
- app.js: Cart, checkout, product management and order management
- config.js: Supabase connection settings (public URL + anon key only)
- supabase-schema.sql: Database tables and Row Level Security policies

STEP 1 - CONNECT SUPABASE
1. Open your Supabase project.
2. Open Project Settings -> API (or API Keys).
3. Copy the Project URL and anon/public key.
4. Open config.js and replace the two PASTE_... values.
5. NEVER use the service_role/secret key in this website.

STEP 2 - CREATE DATABASE
1. Supabase -> SQL Editor -> New query.
2. Open supabase-schema.sql, copy all contents, paste into SQL Editor.
3. Click Run.

STEP 3 - CREATE YOUR ADMIN LOGIN
1. Supabase -> Authentication -> Users -> Add user.
2. Enter your own email and a strong password. Confirm the user if asked.
3. Copy the new user's UUID.
4. In SQL Editor run this command, replacing the example UUID:
   insert into public.admins (user_id) values ('YOUR-USER-UUID');
5. Open your website and click Admin login. Sign in with that email/password.

STEP 4 - ADD PRODUCTS
1. Sign in through Admin login.
2. Use Products -> Add/edit product.
3. Add title, category, PKR price, preview image URL, optional delivery URL and description.
4. Tick Publish product and save.

STEP 5 - DEPLOY TO VERCEL
1. Upload these files to a GitHub repository (keep index.html at repository root).
2. In Vercel click Add New -> Project and import that GitHub repository.
3. Framework Preset: Other. Build command and Output Directory can be left empty/default for a plain static site.
4. Deploy. Vercel will provide a vercel.app URL.
5. Any future code changes: commit/push to GitHub; Vercel redeploys automatically.

PAYMENTS / IMPORTANT LIMITS
- JazzCash/Easypaisa number configured: 03267981140.
- This build records orders and payment references. It does NOT automatically verify bank/mobile-wallet payments.
- Automatic verification requires approved merchant credentials/API integration from JazzCash/Easypaisa.
- International card payments are not activated yet. Connect an eligible payment provider (for example Stripe or PayPal, subject to country/business eligibility) before accepting card payments.
- Do not put private service_role keys, database passwords or payment secrets in config.js or public GitHub files.
- Digital download URLs entered in product admin are not protected/private in this starter version. For paid-only downloads, implement signed URLs or a secure server-side delivery flow before selling sensitive files.

SECURITY NOTE
The SQL policies protect admin-only product/order operations. Public checkout is intentionally allowed. For production commerce, validate prices and product IDs on a trusted server/edge function rather than trusting browser-submitted totals, and add spam/rate limiting and a secure digital delivery process.
