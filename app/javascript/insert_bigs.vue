<template>
  <draggable v-model="bigs" :options="bigsOption" class="bigs">
    <div v-for="big in bigs">{{big.name}}</div>
  </draggable>
</template>
<script>
import draggable from 'vuedraggable'
let name = null
let content = null
export default {
  components: {draggable},
  data(){return{
    bigs:[{name:'LargeGroup',flag:true,
      small_groups:[{name:name,cards:[{content:content}]}]}],
    bigsOption:{
        group:{
          name: "lists",
          pull: "clone",
          put: false,
        },
      sort: false
    },
    smallsOption:{
        group:{
          name: "smalls",
          pull: "clone",
          put: false,
        },
      sort: false
    }
  }}
}
</script>
<style>
 .bigs{
  height:50px;
  width:100px;
  text-align:center;
  padding:15px 0;
  background-color: red;
  border-color: white;
  cursor: grab;

 }
</style>