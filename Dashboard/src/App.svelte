<script>import "./app.css";
import Login from "./lib/Login.svelte";
import {currentUser} from './lib/pocketbase';
import Psk from './lib/Psk.svelte'

</script>


<style>
    .container {
    display: flex;
    justify-content: center; /* Horizontal centering */
    align-items: center;    /* Vertical centering */
    height: 100vh;         /* Full viewport height */
  }
  .pskTable {
    display: flex;
    justify-content: center; /* Horizontal centering */
    align-items: center;    /* Vertical centering */
    height: 100vh;     /* Full viewport height */
    width: 100%;
  }
</style>

{#if $currentUser}

    <!-- When logged in, show the PSK table -->
    <div class="pskTable">
        <Psk></Psk>
    </div>
    
    
    {:else}
    <div class="container">
        <Login></Login>
    </div>  
{/if}





