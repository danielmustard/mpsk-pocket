<script lang="ts">
    import {currentUser, pb} from './pocketbase';
    import { writable } from 'svelte/store';
    import { onMount } from 'svelte';
    import { Button } from "$lib/components/ui/button/index.js";
    import * as Card from "$lib/components/ui/card/index.js";
    import { Input } from "$lib/components/ui/input/index.js";
    import { Label } from "$lib/components/ui/label/index.js";

    // Reactive store for the display name
    export let displayName = writable<string | null>(null);


    async function login(){
        const loginData = await pb.collection('users').authWithOAuth2({ provider: 'microsoft' });
        displayName.set(loginData.meta.rawUser.displayName);
    }
    

</script> 
  

{#if $currentUser}
    <p>
        Signed in as {$displayName}
    </p>
    {:else}
        <Card.Root class="w-full max-w-sm">
            <Card.Header>
              <Card.Title class="text-2xl">Login</Card.Title>
              <Card.Description>Sign in using Microsoft Account</Card.Description>
            </Card.Header>
            <Card.Footer>
              <Button class="w-full" onclick={login}>Sign in</Button>
            </Card.Footer>
          </Card.Root>
{/if}