/// <reference types="cypress" />

context('Group CSV import', () => {
  beforeEach(() => {
    cy.clearCookies()
    cy.visit('http://localhost:3000/users/sign_in')
    cy.loginAsAdmin()
  })

  it('create multiple groups', () => {
    cy.contains('Groups').click()
    cy.contains('Import CSV').click()
    cy.get('textarea').invoke('val', 'name,votes\nGroup 1,1\nGroup 2,2\nGroup 3,3')
    cy.contains('Submit').click()

    cy.get('.alert.alert-info').should('contain', '3 groups were successfully updated.')
  })

  it('Submit invalid information', () => {
    cy.contains('Groups').click()
    cy.contains('Import CSV').click()
    cy.get('textarea').invoke('val', 'name,votes\nGroup 1,1\nGroup 2,-2\nGroup 3,3')
    cy.contains('Submit').click()

    cy.get('.alert.alert-danger').should('contain', 'Validation failed: Available votes must be greater than or equal to 1')
  })
})
