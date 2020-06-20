/// <reference types="cypress" />

context('Organization visibility', () => {
  before(() => {
    cy.clearCookies()
    cy.visit('http://localhost:3000/users/sign_in')
  })
  afterEach(() => {
    cy.logout()
  })

  it('superadmin can see all votings and groups', () => {
    cy.loginAsSuperadmin()
    cy.get('table').should('contain', 'Exploradores de Madrid - Weather voting')
    cy.get('table').should('contain', 'Sample organization - Weather voting')

    cy.visit('http://localhost:3000/groups')
    cy.get('table').should('contain', 'Group 1 Exploradores de Madrid')
    cy.get('table').should('contain', 'Group 1 Sample organization')
  })

  it('admin from one org can see their votings but not others', () => {
    cy.loginAsAdmin()
    cy.get('table').should('contain', 'Exploradores de Madrid - Weather voting')
    cy.get('table').should('not.contain', 'Sample organization - Weather voting')

    cy.visit('http://localhost:3000/groups')
    cy.get('table').should('contain', 'Group 1 Exploradores de Madrid')
    cy.get('table').should('not.contain', 'Group 1 Sample organization')
  })

  it('voter from one org can see their votings but not others', () => {
    cy.loginAsSuperadmin()
    cy.visit('http://localhost:3000/groups')
    cy.loginAsGroup('Group 1 Exploradores de Madrid')
    cy.get('table').should('contain', 'Exploradores de Madrid - Weather voting')
    cy.get('table').should('not.contain', 'Sample organization - Weather voting')
  })
})
