1. CheckAlias - Developed during the company's domain migration in 2023, this script was used to test dynamic generation of new email addresses. It saved a transcript of the process which underwent manual verification to ensure accuracy. A later script, Swap Primary Email, was then used to commit the new addresses.

2. Content Search Purge - Designed to work alongside user-initiated In-Place eDiscovery Content Searches in the Exchange portal. Once content search samples have been reviewed for accuracy, this script soft-purges the search's results from Exchange.

This script was developed following an incident where the HR Director accidentally emailed the hourly pay scale to the entire company. Yikes!

3. Disable O365 Analytics - Gathers data on who is receiving Microsoft Viva Briefing emails and allows an administrator to opt out an account should an individual find them to be a nuisance. (Most do)

4. Expanding Archive - Enables Automatically Expanding Email Archives for an Exchange account. Microsoft places a default limit on Exchange archives, but enabling automatic expansion allows the archive to expand in 10GB increments for accounts who need more archive space than the default allows.

5. Litigation Hold - Verifies the current Litigation Hold state of accounts and prompts an administrator to enable it, if required.

6. Swap Primary Email - The companion script to CheckAlias. Deployed in 2023, it dynamically generated the new email addresses for all accounts using their account properties and configured it as the new UPN. It finishes by terminating active Login Sessions to force re-authentication under the new UPN.