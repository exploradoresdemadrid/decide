/// <reference types="cypress" />

context('Group CSV import', () => {
  beforeEach(() => {
    cy.clearCookies()
    cy.visit('http://localhost:3000/users/sign_in')
    cy.loginAsAdmin()
  })

  it('create multiple groups', () => {
    cy.contains('groups').click()
    cy.contains('Import CSV').click()
    cy.get('textarea').invoke('val', 'ID (do not modify),Name,Number (optional),Email,Exploradores de Madrid\n92613895-026b-42e2-b08f-b1193e4b8e18,Group 1,1,foo+1@bar.com,1\n1cac7a00-7d65-46da-99c7-d47e0bc6ea63,Group 2,2,foo+2@bar.com,3\n16a16967-884b-4f78-ad86-e348d4ae3e89,Group 3,3,foo+3@bar.com,5')
    cy.get('.csv-import form .btn').click()

    cy.get('.alert.alert-info').should('contain', '3 groups were successfully updated.')
  })

  it('Submit invalid information', () => {
    cy.contains('groups').click()
    cy.contains('Import CSV').click()
    cy.get('textarea').invoke('val', 'ID (do not modify),Name,Number (optional),Email,Exploradores de Madrid\n92613895-026b-42e2-b08f-b1193e4b8e18,Group 1,1,foo+1@bar.com,1\n1cac7a00-7d65-46da-99c7-d47e0bc6ea63,Group 2,2,foo+2@bar.com,3\n16a16967-884b-4f78-ad86-e348d4ae3e89,Group 3,3,foo+3@bar.com,-5')
    cy.get('.csv-import form .btn').click()

    cy.get('.alert.alert-danger').should('contain', 'Validation failed: Votes must be greater than or equal to 0')
  })
})
