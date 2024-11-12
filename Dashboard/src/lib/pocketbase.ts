import PocketBase from 'pocketbase';

import { writable } from 'svelte/store';

export const pb = new PocketBase('https://pocket.i.mustard.ovh')

export const currentUser = writable(pb.authStore.model);

pb.authStore.onChange((auth) =>{
    console.log('Authstore Channged', auth);
    currentUser.set(pb.authStore.model);
});

