# mpsk-pocket
💥The goal: Provide a modern and easy to use front end dashboard that allows users to register devices in a database. The data registered in the database should then be queryable by FreeRADIUS.

## Why? 🤔
- Alhough lots of devices support 802.1x out of the box, there are still many that do not, this tool aims to make it easy to provide secure wifi to those devices that require the use of a WPA-PSK.
- I wanted to learn more about Svelte and this seemed like a good project to build something useful.
- Pocketbase is cool and I wanted to try it out.

## Technologies Used

| Frontend                | Backend                 |
|------------------------|-------------------------|
| Svelte                 | Pocketbase              |
| shadcn-svelte          | FreeRADIUS 4 (Alpha)      |
| Tailwind CSS           | Podamn                  |

# To get this working you will also need to create an Azure AD application with the following permissions:
- email
- user.Read
These permissions allow the user to authenticate against AzureAD and get a valid access token for Pocketbase.

* Slight note: This is a work in progress and we have to use the alpha version of FreeRADIUS 4 as this supports more creative querying of rest APIs.
