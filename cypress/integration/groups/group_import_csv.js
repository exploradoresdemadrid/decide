/// <reference types="cypress" />

context('Group CSV import', () => {
  before(() => {
    cy.clearCookies()
    cy.visit('http://localhost:3000/users/sign_in')
    cy.loginAsAdmin()
  })

  it('create multiple groups', () => {
    cy.contains('Grupos').click()
    cy.contains('Importar CSV').click()
    cy.get('textarea').invoke('val', 'name,votes\nGroup 1,1\nGroup 2,2\nGroup 3,3')
    cy.contains('Enviar').click()
    cy.contains('Grupos').click()

    cy.get('.alert.alert-info').should('contain', 'Se han actualizado 3 grupos.')
  })

})
