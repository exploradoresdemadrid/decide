context('Group login', () => {
  const uuid = () => Cypress._.random(0, 1e6)
  const groupName = 'Sample name ' + uuid()

  before(() => {
    cy.loginAsAdmin()
    cy.createGroup(groupName)
  })

  beforeEach(() => {
    cy.clearCookies()
  })

  it('use valid auth code', () => {
    cy.loginAsGroup(groupName)
    cy.get('.navbar').should('contain', groupName)
  })

  it('use invalid auth code', () => {
    cy.loginWithCode('123456')
    cy.get('.alert.alert-danger').should('contain', 'Code is invalid or expired')
  })
})
