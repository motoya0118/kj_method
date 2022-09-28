<template>
  <draggable v-model="cards" :options="cardsOption" class="cards">
    <div v-for="card in cards">{{card.content}}</div>
  </draggable>
</template>
<script>
import draggable from 'vuedraggable'

export default {
  components: {draggable},
  data(){return{
    cards:[{content:'card',flag:true}],
    // smalls:[{name:'small',cards:[{name:'card'}]}]
    cardsOption:{
        group:{
          name: "cards",
          pull: "clone",
          put: false,
        },
      sort: false
    }
  }}
}
</script>
<style>
 .cards{
  height:50px;
  width:100px;
  text-align:center;
  padding:15px 0;
  background-color: white;
  border-color: white;
  cursor: grab;

 }

</style>