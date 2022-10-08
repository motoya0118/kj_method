<template>
  <div v-if="!list.edit" class="list" @click="oneClickBig(list)">
    <h6>{{ list.name }}</h6>
    <hr />
    <draggable v-model="list.small_groups" :options="smallOption" class="dragArea" @change="smallMoved">
      <div v-if="!small.edit" v-for="(small, index) in list.small_groups" class="small small-body" @click.stop="oneClickSmall(small)">
        {{ small.name }}
        <draggable v-model="small.cards" :options="cardOption" class="dragArea" @change="cardMoved">
          <div v-if="!card.edit" v-for="(card, index) in small.cards" class="card card-body" @click.stop="oneClickCard(card)">
            {{ card.content }}
          </div>
          <input v-else type="text" maxlength="30" class="form-control" v-model="card.content" v-on:blur="cardBlur(card)" v-focus></input>
        </draggable>
      </div>
      <input v-else type="text" maxlength="30" class="form-control" v-model="small.name" v-on:blur="smallBlur(small)" v-focus></input>
    </draggable>
  </div>
  <input v-else type="text" maxlength="30" class="form-control" v-model="list.name" v-on:blur="listBlur(list)" v-focus></input>
</template>

<script>
import draggable from 'vuedraggable'




export default{
  components: { draggable },
  props: ["list"],

  data: function(){
      return {
          edit: false,
          message: "",
          result: [],
          delay: 300,
          clicks: 0,
          timer: null,
          smallOption:{
            group: 'smalls',
            disabled: window.store.disabled},
          cardOption:{
            group: 'cards',
            disabled: window.store.disabled}
        }
  },
  directives: {
        focus: {
            // ディレクティブ定義
            inserted: function (el) {
                el.focus();
            }
        }
    },
  methods: {
    smallMoved: function(event) {
      const evt = event.added || event.moved
      if (evt == undefined){ return }
        const element = evt.element
        if (element.flag == undefined){
          window.store.lists.forEach(big =>{
            big.small_groups.forEach(small => {
              if(small.id == element.id){
                var data = new FormData
                data.append("small[large_group_id]", big.id)
                data.append("small[position]", evt.newIndex + 1)
                // console.log(`list_index:${list_index}, element.id:${element.id}`)a
                Rails.ajax({
                    url: `/small_groups/${element.id}/move`,
                    type: "PATCH",
                    data: data,
                    dataType: "json",
                 })
                }
              })
            })          
          }else{
            window.store.lists.forEach(big => {
              big.small_groups.forEach(small =>{
                if (small.id == undefined){
                  const big_index = window.store.lists.indexOf(big)
                  const small_index = big.small_groups.indexOf(small)
                  // console.log(this.list.large_groups[small_index])
                  this.list.small_groups[small_index].cards.splice(0,1)
                  var data = new FormData
                  data.append("small[large_group_id]", window.store.lists[big_index].id)
                  data.append("small[position]", evt.newIndex + 1)
                  data.append("small[name]", small.name)
                  data.append("small[place_id]", window.store.id)
                  Rails.ajax({
                    url: `/small_groups`,
                    type: "POST",
                    data: data,
                    dataType: "json",
                  })
                }
              })
            })
        }
      },
      cardMoved: function(event) {
        const evt = event.added || event.moved
        if (evt == undefined){ return }
        const element = evt.element
        if (element.flag == undefined){
          window.store.lists.forEach(big => {
            big.small_groups.forEach(small =>{
              small.cards.forEach(card =>{
                if (card.id == element.id){
                  var data = new FormData
                  data.append("card[small_group_id]",small.id)
                  data.append("card[position]", evt.newIndex + 1)
                  Rails.ajax({
                    url: `/cards/${element.id}/move`,
                    type: "PATCH",
                    data: data,
                    dataType: "json",
                  })
                }
              })
            })              
          });
        } else {
          window.store.lists.forEach(big => {
            big.small_groups.forEach(small =>{
              small.cards.forEach(card =>{
                if (card.id == undefined){
                  var data = new FormData
                  data.append("card[small_group_id]",small.id)
                  data.append("card[position]", evt.newIndex + 1)
                  data.append("card[content]", card.content)
                  data.append("card[place_id]", window.store.id)   
                  Rails.ajax({
                    url: `/cards`,
                    type: "POST",
                    data: data,
                    dataType: "json",
                  })
                }
              })
            })
          })
        }
          
        },
        deleteCard: function(dbl_card) {
          window.store.lists.forEach( big => {
            big.small_groups.forEach( small =>{
              small.cards.forEach( card =>{
                if (card.id == dbl_card){
                  const card_index = small.cards.indexOf(card)
                  const small_index = big.small_groups.indexOf(small)
                  this.list.small_groups[small_index].cards.splice(card_index,1)
                  Rails.ajax({
                    url: `/cards/${card.id}`,
                    type: "DELETE",
                    dataType: "json",
                  })
                  }
                })
              }
            )}
          )
        },
        deleteSmall: function(dbl_small) {
          window.store.lists.forEach( big => {
            big.small_groups.forEach( small =>{
              if (small.id == dbl_small){
                const small_index = big.small_groups.indexOf(small)
                this.list.small_groups.splice(small_index,1)
                Rails.ajax({
                  url: `/small_groups/${small.id}`,
                  type: "DELETE",
                  dataType: "json",
                  })
                }
              })
            }
          )},
        cardBlur: function(card){
          card.edit = false
          var data = new FormData
          data.append("card[content]", card.content)
          Rails.ajax({
                    url: `/cards/${card.id}/move`,
                    type: "PATCH",
                    data: data,
                    dataType: "json",
                  })
        },
        smallBlur: function(small){
          small.edit = false
          var data = new FormData
          data.append("small[name]", small.name)
          Rails.ajax({
                    url: `/small_groups/${small.id}/move`,
                    type: "PATCH",
                    data: data,
                    dataType: "json",
                  })
        },
        listBlur: function(list){
          list.edit = false
          var data = new FormData
          data.append("place[name]", list.name)
          Rails.ajax({
                    url: `/large_groups/${list.id}`,
                    type: "PATCH",
                    data: data,
                    dataType: "json",
                  })
        },
        oneClickCard: function(card){
          if(window.store.disabled){return}
          this.clicks++ 
          if(this.clicks === 1) {
            var self = this
            this.timer = setTimeout(function() {
              card.edit = true
              self.clicks = 0
            }, this.delay);
          } else{
             clearTimeout(this.timer);  
             this.deleteCard(card.id);
             this.clicks = 0
          }        	
        },
        oneClickSmall: function(small){
          if(window.store.disabled){return}
          this.clicks++ 
          if(this.clicks === 1) {
            var self = this
            this.timer = setTimeout(function() {
              small.edit = true
              self.clicks = 0
            }, this.delay);
          } else{
             clearTimeout(this.timer);  
             this.deleteSmall(small.id);
             this.clicks = 0
          }        	
        },
        oneClickBig: function(big){
          if(window.store.disabled){return}
          this.clicks++ 
          if(this.clicks === 1) {
            var self = this
            this.timer = setTimeout(function() {
              big.edit = true
              self.clicks = 0
            }, this.delay);
          } else{
             clearTimeout(this.timer);
             this.$emit('delete',big.id);  
             self.clicks = 0
          }        	
        }                        
        },
        

  }
</script>

<style scoped>
.dragArea{
  min-height: 20px;
}
  
.list{
  list-style: none;
  border-style: solid;
  border-color: red;
  background: #E2E4E6;
  border-radius: 3px;
  display: inline-block;
  margin: 5px;
  padding: 10px;
  vertical-align: top;
  width: 270px;
  cursor: grab;
}
.small {
  list-style: none;
  width: 200px;
  padding: 0;
  margin: 8px;
  border-style: solid;
  border-color: blue;
  background: yellow;
  cursor: grab;
}
.card {
  background-color: white;
  margin-bottom: 4px;
  padding: 4px !important;
  cursor: grab;
  white-space: pre-line;
  word-break: break-all;
}
input{
  display: block;
  width: 200px;
  height: 50px;
  vertical-align: text-top;
}


</style>