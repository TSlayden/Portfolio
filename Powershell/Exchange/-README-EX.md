1. CheckAlias - The company changed its primary domain name in 2023 and this script was used to test stitching together the new domain names dynamically. A transcript was generated from the process which underwent a manual review to ensure accuracy. A later script, Swap Primary Email, was used to commit the swap to the new domain.

2. Content Search Purge - Intended to be used in conjunction with a user-initiated In-Place eDiscovery Content Search in the Exchange portal. Once some samples from the content search have been reviewed to verify the search's accuracy, this script soft-purges the results from Exchange.

This script was written following the HR Director accidentally emailing the hourly pay scale out to the entire company. Yikes!

3. Disable O365 Analytics - Used to gather info on who is receiving Microsoft Viva Briefing emails. Allows opting-out of those emails should a user find them to be a nuisance. (Most do)

4. Expanding Archive - Used to enable Automatically Expanding Email Archives for a user in Exchange. Microsoft places a default limit on Exchange archives, but enabling Automatic Expanding allows the archive to expand in 10GB increments for users who need more archive space than the default allows.

5. Litigation Hold - Verifies the Litigaiton hold state of users and prompts to enable it, if required.

6. Swap Primary Email - The company changed its primary domain name in 2023 and this script was used to update all users' email addresses to the new domain. It dynamically generated the new email address using their account properties and set it as the UPN. It also disconnects all Login Sessions to ensure everyone logged in with their new UPN.