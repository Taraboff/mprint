<template>
  <transition name="fade">
    <div class="modal" v-if="show" >
      <div class="modal__backdrop" @click="closeModal(true)"/>

      <div class="modal__dialog">
        <div class="modal__header">
          <slot name="header" />
        </div>

        <div class="modal__body">
          <slot name="body" />
        </div>

        <div class="modal__footer">
          <slot name="footer" />
        </div>
      </div>
    </div>
  </transition>
</template>

<script>
export default {
  name: "Modal",
  data() {
    return {
      show: false,
    };
  },
  methods: {
    closeModal(cancel) {
      this.show = false;
      document.querySelector("body").classList.remove("overflow-hidden");
      if (cancel) this.$parent.appKey++;
    },
    openModal() {
      this.show = true;
      document.querySelector("body").classList.add("overflow-hidden");
    },
  },
};
</script>


<style scoped>
.modal {
  position: fixed;
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;
  z-index: 9;
  overflow-x: hidden;
  overflow-y: auto;
}
  .modal__backdrop {
    position: fixed;
    top: 0;
    right: 0;
    bottom: 0;
    left: 0;
    background-color: rgba(0, 0, 0, 0.3);
    z-index: 1;
  }
  .modal__dialog {
    position: relative;
    width: 600px;
    background-color: #ffffff;
    border-radius: 5px;
    margin: 100px auto;
    display: flex;
    flex-direction: column;
    z-index: 2;
    @media screen and (max-width: 992px) {
      width: 90%;
    }
  }
  .modal__close {
    width: 30px;
    height: 30px;
    display: none;
  }
  .modal__header {
    display: flex;
    align-items: flex-start;
    justify-content: space-between;
    padding: 30px 40px 10px;
    font-size: 1em;
  }
  .modal__body {
    padding: 10px 40px 10px;
    overflow: auto;
    display: flex;
    flex-direction: column;
    align-items: stretch;
  }
  .modal__footer {
    padding: 30px 20px 30px;
  }

.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.2s;
}
.fade-enter,
.fade-leave-to {
  opacity: 0;
}
</style>