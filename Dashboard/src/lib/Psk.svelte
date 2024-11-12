<script lang="ts">
    import {onMount, onDestroy} from 'svelte';
    import {currentUser, pb} from './pocketbase'
    import * as Table from "$lib/components/ui/table/index.js";
    import { Button } from "$lib/components/ui/button/index.js";

    let pskValues = [];
    let DeviceMac = ''; // Add this
    let Psk = '';      

    let isOverlayOpen = false;

    // Create a new PSK 
    async function getListValues(){
        const resultList = await pb.collection('psk').getList(1,50, {
            sort: 'created'
        });
        //console.log(resultList)
        pskValues = resultList.items
    }

    onMount(async () => {
        getListValues();   
    });

    // Create a new PSK 
    async function makeNewPsk(DeviceMac: string){
        getListValues();
        
        const data = {
            user : $currentUser.id,
            DeviceMac: DeviceMac,
            Psk: 'EHU-' + Array.from(crypto.getRandomValues(new Uint8Array(3))).map(b => b.toString(16).padStart(2,'0')).join('')
        };
        console.log(pskValues.length)
        if (pskValues.length < 5){
        console.log(pskValues)
            const createdPsk = await pb.collection('psk').create(data);
            getListValues();
        }

    }

    async function deletePsk(recordId){
        await pb.collection('psk').delete(recordId);
        getListValues();
    }



</script>

{#if isOverlayOpen == false}
<div class="psk">
        <div>
            <div class="w-full max-w-4xl mx-auto">
                <Table.Root class="border rounded-lg">
                    <Table.Caption class="mb-4 text-lg">A list of keys that allow access to Acme WiFi network.</Table.Caption>
                    <Table.Header>
                      <Table.Row>
                        <Table.Head class="w-[200px] text-center">Date Created</Table.Head>
                        <Table.Head class="text-center">WiFi Key</Table.Head>
                        <Table.Head class="text-center">Device Mac</Table.Head>
                        <Table.Head class="w-[150px] text-center">
                            {#if pskValues.length > 0}
                                <Button size="sm" on:click={() => {isOverlayOpen = true}}>Create ➕</Button>
                            {/if}
                        </Table.Head>
                        
                      </Table.Row>
                    </Table.Header>
                    <Table.Body>
                      {#if pskValues.length === 0}
                        <Table.Row>
                          <Table.Cell colspan="3" class="text-center py-12">
                            <div class="flex flex-col items-center gap-4">
                              <p class="text-muted-foreground text-lg">You currently have no keys connected to your account.</p>
                              <Button on:click={() => {isOverlayOpen = true}}>Create Key</Button>
                            </div>
                          </Table.Cell>
                        </Table.Row>
                      {:else}
                        {#each pskValues as psk (psk.id)}
                          <Table.Row class="hover:bg-muted/50">
                            <Table.Cell class="font-mono text-center">{new Date(psk.created).toLocaleDateString()}</Table.Cell>                        
                            <Table.Cell class="font-mono font-medium text-center">{psk.Psk}</Table.Cell>
                            <Table.Cell class="font-mono font-medium text-center">{psk.DeviceMac}</Table.Cell>
                            <Table.Cell class="text-center">
                                <Button size="sm" variant="destructive" on:click={() => deletePsk(psk.id)}>Delete Key</Button>
                            </Table.Cell>
                          </Table.Row>
                        {/each}
                      {/if}
                    </Table.Body>
                  </Table.Root>
            </div>
        </div>
</div>
{/if}

{#if isOverlayOpen}
<div class="fixed inset-0 bg-black/50 flex items-center justify-center">
    <div class="bg-white p-6 rounded-lg shadow-lg w-96">
        <h2 class="text-xl font-bold mb-4">Create New PSK</h2>
        
        <form on:submit|preventDefault={() => {
            makeNewPsk(DeviceMac);
            isOverlayOpen = false;
        }} class="space-y-4">
            <div class="space-y-2">
                <label for="macAddress" class="block text-sm font-medium">MAC Address</label>
                <input
                    type="text"
                    id="macAddress" 
                    bind:value={DeviceMac}
                    placeholder="001122334455"
                    class="w-full p-2 border rounded-md"
                    maxlength="12"
                    required
                    autocomplete="off"
                    title="Please enter exactly 12 hexadecimal characters (0-9, A-F)"
                />
                <p class="text-sm text-gray-500">Please enter only letters and numbers from the MAC address, no colons or other symbols.</p>
            </div>

            <div class="flex justify-end space-x-2">
                <Button variant="outline" on:click={() => {
                    isOverlayOpen = false;
                }}>
                    Cancel
                </Button>
                <Button type="submit">
                    Generate WiFi Key
                </Button>
            </div>
        </form>
    </div>
</div>
{/if}

